from collections.abc import Set
from typing import List, Tuple, Union
import requests
import json 
from agents.space_handler import SpaceHandler
import subprocess

class PDDLInterface:

    COLOURS = ['red', 'blue', 'orange', 'black', 'green']
    DATA_KEYS = ['actors', 'tasks', 'nodes', 'mines']
    ACTIONS = ['move', 'mine', 'pick-up', 'drop', 'start-building', 'deposit', 'complete-building']

    @staticmethod
    # Function to write a problem file
    # Complete this function

    def writeProblem(world_info, file="pddl/problem.pddl"):
        # Function that will write the problem file
        # write a simple config that will create 10 randomly generated nodes, and 6 fixed tasks (again, randomly generated).
        # Each task will require a different number of resources to solve
        actors = world_info['actors'].values()
        tasks = world_info['tasks'].values()

        with open('./pddl/world_info.txt', "w") as fiel:
            json.dump(world_info, fiel, indent=4)

        spaceHandler = SpaceHandler()
        
        with open(file, "w") as file:

            file.write("(define(problem craft-bots-prob)")
            file.write(spaceHandler.newline * 2)
            file.write("(:domain craft-bots)")
            file.write(spaceHandler.newline * 2)

        ###################################################### OBJECTS ######################################################

            file.write("(:objects" + spaceHandler.newline)

            for world_info_data_key in PDDLInterface.DATA_KEYS:
                file.write(spaceHandler.tab)
                for actor in world_info[world_info_data_key].values():
                    file.write(f"{world_info_data_key[0]}{str(actor['id'])} ")
                file.write(f"- {world_info_data_key[:-1]}" + spaceHandler.newline)

            file.write(spaceHandler.tab)
            for i in PDDLInterface.COLOURS:
                file.write(str(i) + spaceHandler.space)
            file.write(f"- color" + spaceHandler.newline)

            file.write(spaceHandler.close_paren)
            file.write(spaceHandler.newline * 2)

        ######################################################## INIT ########################################################

            file.write("(:init" + spaceHandler.newline)

            file.write("    ;; setting the initial node for each actor\n")
            for actor in actors:
                actor_id = str(actor['id'])
                actor_node = str(actor['node'])

                file.write(spaceHandler.tab)
                file.write(f"(actor_location a{actor_id} n{actor_node})")
                file.write(spaceHandler.newline)

                file.write(spaceHandler.tab)
                file.write(f"(is_not_working a{actor_id})")
                file.write(spaceHandler.newline)

                file.write(spaceHandler.tab)
                file.write(f"(= (total_resource_in_inventory a{actor_id}) 0)")
                file.write(spaceHandler.newline)
                file.write(spaceHandler.newline)
    
            file.write(spaceHandler.newline)
            file.write("    ;; setting the connection between each nodes\n")
            for edge in world_info['edges'].values():
                node_A = str(edge['node_a'])
                node_B = str(edge['node_b'])
                file.write(spaceHandler.tab)
                file.write(f"(connected n{node_A} n{node_B})")
                file.write(spaceHandler.tab)
                file.write(f"(connected n{node_B} n{node_A})")
                file.write(spaceHandler.newline)
            file.write(spaceHandler.newline)

            file.write("    ;; setting the mines details\n")
            for mine in world_info['mines'].values():
                mine_id = str(mine['id'])
                mine_node = str(mine['node'])
                mine_color = PDDLInterface.COLOURS[mine['colour']]
                file.write(spaceHandler.tab)
                file.write(f"(mine_detail m{mine_id} n{mine_node} {mine_color})" + spaceHandler.newline)
            file.write(spaceHandler.newline)

            file.write("    ;; set the variables site_not_created\n")
            for task in tasks:
                task_id = str(task['id'])
                task_node = str(task['node'])

                file.write(spaceHandler.tab)
                file.write(f"(is_task_available t{task_id})")
                file.write(spaceHandler.newline)

                file.write(spaceHandler.tab)
                file.write(f"(site_not_created n{task_node} t{task_id})" + spaceHandler.newline)
                
                file.write(spaceHandler.tab)
                file.write(f"(building_not_built t{task_id} n{task_node})")
                file.write(spaceHandler.newline)


            file.write(spaceHandler.newline)

            file.write("    ;; set the variables not_carrying\n")
            for actor in actors:  
                actor_id = str(actor['id'])
                for color in PDDLInterface.COLOURS:
                    file.write(spaceHandler.tab)
                    file.write(f"(= (carrying_color a{actor_id} {color}) 0)" + spaceHandler.newline)
                file.write(spaceHandler.newline)
                        
            file.write("    ;; set the resource_count function\n")
            for task in tasks:
                task_id = str(task['id'])
                task_node = str(task['node'])
                resource_list = task['needed_resources']

                file.write(spaceHandler.tab)
                file.write(f"(= (total_resource_required t{task_id} n{task_node}) {str(sum(resource_list))})")
                file.write(spaceHandler.newline)

                for index, color in enumerate(PDDLInterface.COLOURS):
                    resource_needed = resource_list[index]

                    if resource_needed>0:
                        file.write(spaceHandler.tab)
                        file.write(f"(= (resource_count t{task_id} {color}) {str(resource_needed)})")
                        file.write(spaceHandler.newline)
                file.write(spaceHandler.newline)

            file.write(spaceHandler.close_paren)
            file.write(spaceHandler.newline * 2)

        ######################################################## GOAL ########################################################

            file.write("(:goal" + spaceHandler.newline)
            file.write(spaceHandler.tab + '(and' + spaceHandler.newline)

            for task in tasks:
                task_id = str(task['id'])
                task_node = str(task['node'])

                file.write(spaceHandler.tab * 2)
                file.write(f"(building_built t{task_id} n{task_node})" + spaceHandler.newline)

            file.write(")))" + spaceHandler.newline)

    @staticmethod
    # Completed already, will read a generated plan from file
    def readPDDLPlan(file: str):
        plan = []
        with open(file, "r") as f:
            line = f.readline().strip()
            while line:
                tokens = line.split()
                action = tokens[1][1:]
                params = tokens [2:-1]
                # remove trailing bracket
                params[-1] = params[-1][:-1]
                # remove character prefix and convert colours to ID
                params = [int(p[1:]) if p not in PDDLInterface.COLOURS else PDDLInterface.COLOURS.index(p) for p in params]
                plan.append((action, params))
                line = f.readline().strip()
            f.close()
        return plan

    @staticmethod
    # Completed already
    def generatePlan(domain: str, problem: str, plan: str, verbose=False):
        # data = {'domain': open(domain, 'r').read(), 'problem': open(problem, 'r').read()}
        # resp = requests.post('https://popf-cloud-solver.herokuapp.com/solve', verify=True, json=data).json()
        # if not 'plan' in resp['result']:
        #     if verbose:
        #         print("WARN: Plan was not found!")
        #         print(resp)
        #     return False
        # with open(plan, 'w') as f:
        #     f.write(''.join([act for act in resp['result']['plan']]))
        # f.close()

        optic_path = '/home/mlb23172/bin/optic-cplex'
        process = subprocess.run([f'{optic_path}', '-N', f'{domain}', f'{problem}'], stdout=subprocess.PIPE)

        process = str(process)
        start_index = process.rindex('Solution Found')

        if start_index == -1:
            return False

        trimmed_response = process[start_index:-2]
        trimmed_response_list = trimmed_response.split('\\n')[4:]
        filtered_list = '\n'.join(list(filter(lambda x: x != "", trimmed_response_list)))

        with open(plan, "w") as file:
            file.write(filtered_list)

        return True

if __name__ == '__main__':
    PDDLInterface.generatePlan("pddl/domain-craft-bots.pddl", "pddl/problem.pddl", "pddl/plan.pddl", verbose=True)
    plan = PDDLInterface.readPDDLPlan('pddl/plan.pddl')
    print(plan)