import time
from agents.PDDLInterfaceTemporal import PDDLInterface
from craftbots.log_manager import Logger
from api import agent_api
from agents.agent import Agent

class Assignment_Agent_Temporal(Agent):

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
        self.state = Assignment_Agent_Temporal.STATE.READY

        # Set the agent to be verbose (printing out commands)
        self.verbose = 1


    # Function to choose the next commands
    # Main function for writing plans etc.
    # does not execute anything, is purely for testing plan
    def get_next_commands(self):
        return self.get_next_commands_v1()
        # You can use this to test your PDDL
        PDDLInterface.writeProblem(world_info=self.world_info)

        # Now try to generate a plan
        PDDLInterface.generatePlan("agents/domain-craft-bots-temporal.pddl", "agents/problem-temporal.pddl", "agents/plan-temporal.pddl", verbose=True)
        

    # A more complete version, which only creates a plan etc if needed
    # Rename to get_next_commands(self) to use
    def get_next_commands_v1(self):
        #  Completed, do not need to edit

        # If they are ready for instructions
        if self.state == Assignment_Agent_Temporal.STATE.READY:
           
            # Get a list of tasks and add them to a list
            # check if they are all completed
            tasks=[]
            for task in self.world_info['tasks'].values():
                tasks.append(task['completed'])
            
            # If all tasks completed, set state to waiting
            if (all (tasks)):
                self.state = Assignment_Agent_Temporal.STATE.WAITING

            # if all tasks not completed, need to process
            else:
                # Print a list of all completed tasks
                for task in self.world_info['tasks'].values():
                    if task['completed']:
                        print(task['id'])

                # Put agent in planning state
                self.state = Assignment_Agent_Temporal.STATE.PLANNING

                # Generate Problem and plan and prepare to execute
                PDDLInterface.writeProblem(world_info=self.world_info)

                # Now generate a plan
                PDDLInterface.generatePlan("agents/domain-craft-bots-temporal.pddl", "agents/problem-temporal.pddl", "agents/plan-temporal.pddl", verbose=True)

                # Read the plan (completed)
                self.plan = PDDLInterface.readPDDLPlan('agents/plan-temporal.pddl')

                # Set agent to be executing a plan
                self.state = Assignment_Agent_Temporal.STATE.EXECUTING
            
        # If its executing, need to fill in again
        elif self.state == Assignment_Agent_Temporal.STATE.EXECUTING:
            # print('executing')
            # If the plan is zero, i.e. no plan
            if len(self.plan) == 0:
                # set agent to be ready
                self.state = Assignment_Agent_Temporal.STATE.READY
                # Check all the actors, if any are busy, change state to executing
                for actor in self.world_info['actors'].values():
                    if actor['state'] != 0:
                        self.state = Assignment_Agent_Temporal.STATE.EXECUTING

            # Otherwise, if a plan exists, 
            else:
                # Set our first action
                 action, params = self.plan[0]
                 print(self.plan[0])
                 # check if any actors are ready
                 if self.world_info['actors'][params[0]]['state'] == 0:
                    # Pop first action off stack
                    self.plan.pop(0)
                    #  Send action for agent to execute
                    # call send function
                    self.send_action(action, params)
                    
                    self.state = Assignment_Agent_Temporal.STATE.WAITING
                    time.sleep(0.2)

        # if its waiting, set it to executing.  completed
        elif self.state == Assignment_Agent_Temporal.STATE.WAITING:
           # print('waiting, so make it execute')
            self.state = Assignment_Agent_Temporal.STATE.EXECUTING

        # finished thinking
        self.thinking = False

    def get_remaining_resource(self, task_id):
        site_id = self.api.get_field(task_id, "site")
        if site_id == None:
            return False
        deposited_resources = self.api.get_field(site_id, 'deposited_resources')
        needed_resources = self.api.get_field(site_id, 'needed_resources')
        if deposited_resources==None or needed_resources==None:
            return False
        remaining_resources = [a - b for a, b in zip(needed_resources, deposited_resources)]
        return remaining_resources


    # Function that actually carries out the action
    # receives actions and params, 
    def send_action(self, action, params):
        actor_id = params[0]
        actor_node = self.api.get_field(actor_id, "node")
        actor_resources = self.api.get_field(actor_id, 'resources')
        tasks = self.world_info['tasks'].values()

        if action == 'move_between_nodes':
            (_, source, destination) = params
            if source == actor_node and actor_node != destination:
                self.api.move_to(actor_id, destination)
                Logger.info("MOVE", f"Actor{actor_id} node{destination}.")
            return

        elif action == 'setup_site':
            for task in tasks:
                task_id = task['id']
                task_node = task['node']
                if task_node == params[1] == actor_node:
                    self.api.start_site(actor_id, task_id)
                    Logger.info("START SITE", f"Actor{actor_id} node{actor_node} task{task_id}.")
                    break

        elif action == 'mine_resource' or action == 'mine_blue_resource':
            mine_id = params[1]
            node_id = params[2]
            color_id = params[3]
            mine_node = self.api.get_field(mine_id, "node")
            mine_color = self.api.get_field(mine_id,'colour')

            if mine_color == color_id and actor_node == node_id == mine_node:        
                self.api.dig_at(actor_id, mine_id)
                Logger.info("MINE", f"Actor{actor_id} mine{mine_id}.")
            
        elif action == 'mine_orange_resource':
            actor_id_1 = params[0]
            actor_id_2 = params[1]
            orange_mine_id = params[2]

            self.api.dig_at(actor_id_1, orange_mine_id)
            self.api.dig_at(actor_id_2, orange_mine_id)
            Logger.info("MINE", f"Actor{actor_id_1} and Actor{actor_id_2} mine{mine_id}.")

        elif action == 'pick_up_resource' or action == 'pick_up_red_resource' or action == 'pick_up_black_resource':
            (_, node_id, color_id) = params
            for resource in self.world_info['resources'].values():
                resource_id = resource['id']
                resource_node = resource['location']
                resource_color = resource['colour']
                if resource_node == node_id and resource_color == color_id:
                    self.api.pick_up_resource(actor_id, resource_id)
                    Logger.info("PICKUP", f"Actor{actor_id} resource{resource_id}.")
                    break

        elif action == 'deposit':
            (_, node_id, color_id) = params

            for task in tasks:
                task_id = task['id']
                task_node = task['node']
                target_node = self.api.get_field(task_id, "node")
                site_id = self.api.get_field(task_id, "site")

                remaining_resources = self.get_remaining_resource(task_id)
                deposit_resource = len(remaining_resources) > 0 and remaining_resources[color_id] > 0
                
                for resource_id in actor_resources:
                    resource_color = self.api.get_field(resource_id, 'colour')
                    if target_node == node_id == actor_node and resource_color == color_id and deposit_resource:
                        self.api.deposit_resources(actor_id, site_id, resource_id)
                        Logger.info("DEPOSIT", f"Actor{actor_id} site{site_id} resource{resource_id}.")
                        break

        elif action == 'construct_building':
            for task in tasks:
                task_id = task['id']
                target_node = self.api.get_field(task_id, "node")
                site_id = self.api.get_field(task_id, "site")

                remaining_resources = self.get_remaining_resource(task_id)
                if target_node == params[1] and sum(remaining_resources) == 0:
                    self.api.construct_at(actor_id, site_id)
                    Logger.info("CONSTRUCT", f"Actor{actor_id} site{site_id}.")
                    break

        else:
            print('Invalid action')