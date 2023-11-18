import random
import time
# set the root path to the project folder
import sys
sys.path.append('./')
from craftbots.log_manager import Logger
from agents.PDDLInterface import PDDLInterface
from api import agent_api
from craftbots.entities.building import Building
from agents.agent import Agent

class Assignment_Agent(Agent):

    class STATE:
        READY     = 0
        PLANNING  = 1
        EXECUTING = 2
        # this state skips the frame after
        # an action is dispatched to avoid
        # misreading the actor state.
        WAITING   = 3
        DONE      = 4

    api: agent_api.AgentAPI
    pddl_interface: PDDLInterface

    def __init__(self):

        super().__init__()

        # Set an initial state of being ready.
        self.state = Assignment_Agent.STATE.READY

        # Set the agent to be verbose (printing out commands)
        self.verbose = 1


    # Function to choose the next commands
    # Main function for writing plans etc.
    # does not execute anything, is purely for testing plan
    def get_next_commands_testing(self):
        # You can use this to test your PDDL
        PDDLInterface.writeProblem(world_info=self.world_info)

        # Now try to generate a plan
        PDDLInterface.generatePlan("agents/domain-craft-bots.pddl", "agents/problem.pddl", "agents/plan.pddl", verbose=True)
        

    # A more complete version, which only creates a plan etc if needed
    # Rename to get_next_commands(self) to use
    def get_next_commands(self):
        #  Completed, do not need to edit

        # If they are ready for instructions
        if self.state == Assignment_Agent.STATE.READY:
           
            # Get a list of tasks and add them to a list
            # check if they are all completed
            tasks=[]
            for task in self.world_info['tasks'].values():
                tasks.append(task['completed'])
            
            # If all tasks completed, set state to waiting
            if (all (tasks)):
                self.state = Assignment_Agent.STATE.WAITING

            # if all tasks not completed, need to process
            else:
                # Print a list of all completed tasks
                for task in self.world_info['tasks'].values():
                    if task['completed']:
                        print(task['id'])

                # Put agent in planning state
                self.state = Assignment_Agent.STATE.PLANNING

                # Generate Problem and plan and prepare to execute
                PDDLInterface.writeProblem(world_info=self.world_info)

                # Now generate a plan
                PDDLInterface.generatePlan("agents/domain-craft-bots.pddl", "agents/problem.pddl", "agents/plan.pddl", verbose=True)

                # Read the plan (completed)
                self.plan = PDDLInterface.readPDDLPlan('agents/plan.pddl')

                # Set agent to be executing a plan
                self.state = Assignment_Agent.STATE.EXECUTING
            
        # If its executing, need to fill in again
        elif self.state == Assignment_Agent.STATE.EXECUTING:
            # If the plan is zero, i.e. no plan
            if len(self.plan) == 0:
                # set agent to be ready
                self.state = Assignment_Agent.STATE.READY
                # Check all the actors, if any are busy, change state to executing
                for actor in self.world_info['actors'].values():
                    if actor['state'] != 0:
                        self.state = Assignment_Agent.STATE.EXECUTING

            # Otherwise, if a plan exists, 
            else:
                # Set our first action
                 action, params = self.plan[0]
                 # check if any actors are ready
                 if self.world_info['actors'][params[0]]['state'] == 0:
                    # Pop first action off stack
                    self.plan.pop(0)
                    #  Send action for agent to execute
                    # call send function
                    self.send_action(action, params)
                    
                    self.state = Assignment_Agent.STATE.WAITING
                    time.sleep(0.2)

        # if its waiting, set it to executing.  completed
        elif self.state == Assignment_Agent.STATE.WAITING:
            self.state = Assignment_Agent.STATE.EXECUTING

        # finished thinking
        self.thinking = False

    def get_remaining_resource(self, task_id, color_id):
        site_id = self.api.get_field(task_id, "site")
        if site_id == None:
            return False
        deposited_resources = self.api.get_field(site_id, 'deposited_resources')
        needed_resources = self.api.get_field(site_id, 'needed_resources')
        if deposited_resources==None or needed_resources==None:
            return False
        remaining_resources = [a - b for a, b in zip(needed_resources, deposited_resources)]
        return len(remaining_resources) > 0 and remaining_resources[color_id] > 0

    # Function that actually carries out the action
    # receives actions and params, 
    def send_action(self, action, params):
        actor_id = params[0]
        actor_node = self.api.get_field(actor_id, "node")
        actor_resources = self.api.get_field(actor_id, 'resources')

        if action == 'move_between_nodes':
            (_, source, destination) = params
            if source == actor_node and actor_node != destination:
                self.api.move_to(actor_id, destination)
                Logger.info("MOVE", f"Actor{actor_id} node{destination}.")
            return

        task_id = params[1]
        node_id = params[2]
        target_node = self.api.get_field(task_id, "node")
        site_id = self.api.get_field(task_id, "site")
        is_site_not_created = site_id == None
        site_not_available = not is_site_not_created and self.world_info['sites'].get(site_id, None) is None
        site_missing = is_site_not_created or site_not_available
        node_resources = self.api.get_field(node_id,'resources')
    
        if action == 'mine_resource' or action == 'mine_resource_for_task':
            color_id = params[3]
            mine_id = params[4]
            mine_node = self.api.get_field(mine_id, "node")
            mine_color = self.api.get_field(mine_id,'colour')
            mine_resource = self.get_remaining_resource(task_id, color_id)

            if mine_color == color_id and (site_missing or mine_resource) and actor_node == node_id == mine_node:
                self.api.dig_at(actor_id, mine_id)
                Logger.info("MINE", f"Actor{actor_id} mine{mine_id}.")

        elif action == 'pick_up_resource': 
            color_id = params[3]
            pickup_resource = self.get_remaining_resource(task_id, color_id)

            for resource_id in node_resources:
                resource_location = self.api.get_field(resource_id, 'location')
                resource_color = self.api.get_field(resource_id, 'colour')
                if resource_location == node_id == actor_node and resource_color == color_id and (site_missing or pickup_resource):
                    self.api.pick_up_resource(actor_id, resource_id)
                    Logger.info("PICKUP", f"Actor{actor_id} resource{resource_id}.")
                    break
            
        elif action == 'setup_site':
            if site_missing and target_node == node_id == actor_node:
                self.api.start_site(actor_id, task_id)
                Logger.info("START SITE", f"Actor{actor_id} node{actor_node} task{task_id}.")

        elif action == 'deposit':
            color_id = params[3]

            deposit_resource = self.get_remaining_resource(task_id, color_id)
            for resource_id in actor_resources:
                resource_color = self.api.get_field(resource_id, 'colour')
                if target_node == node_id == actor_node and resource_color == color_id and deposit_resource:
                    self.api.deposit_resources(actor_id, site_id, resource_id)
                    Logger.info("DEPOSIT", f"Actor{actor_id} site{site_id} resource{resource_id}.")
                    break
                    
        elif action == 'construct_building':
            if target_node == node_id == actor_node:
                self.api.construct_at(actor_id, site_id)
                Logger.info("CONSTRUCT", f"Actor{actor_id} site{site_id}.")
            
        else:
            print('Invalid action')