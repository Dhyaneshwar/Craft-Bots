import requests
import subprocess

# Defining few simple methods to improve the program readability
#  Function to add space
def space():
    return " "

# Function to add a new line
def newline():
    return "\n"

# Function to add a tab
def tab():
    return "\t"

class PDDLInterface:

    COLOURS = ['red', 'blue', 'orange', 'black', 'green']
    DATA_KEYS = ['actors', 'tasks', 'nodes', 'mines']
    ACTIONS = ['move', 'mine', 'pick-up', 'drop', 'start-building', 'deposit', 'complete-building']

    @staticmethod
    # Function to write a temporal problem file
    def writeProblem(world_info, problem_file_path="agents/problem-temporal.pddl"):
        actors = world_info['actors'].values()
        tasks = world_info['tasks'].values()

        with open(problem_file_path, "w") as file:

            file.write("(define(problem craft-bots-temporal-prob)" + newline())
            file.write(newline())
            file.write("(:domain craft-bots-temporal)" + newline())
            file.write(newline())

        ###################################################### OBJECTS ######################################################

            file.write("(:objects" + newline())

            file.write(tab() + ";; Declaring the objects for the problem" + newline())
            for world_info_data_key in PDDLInterface.DATA_KEYS:
                file.write(tab())
                for actor in world_info[world_info_data_key].values():
                    file.write(f"{world_info_data_key[0]}{str(actor['id'])} ")
                file.write(f"- {world_info_data_key[:-1]}" + newline())

            file.write(tab())
            for i in PDDLInterface.COLOURS:
                file.write(str(i) + space())
            file.write(f"- color" + newline())

            file.write(")")
            file.write(newline() * 2)

        ######################################################## INIT ########################################################

            file.write("(:init" + newline())

            file.write(tab() + ";; setting the initial node for each actor" + newline())
            for actor in actors:
                actor_id = str(actor['id'])
                actor_node = str(actor['node'])

                # Actor's location
                file.write(tab())
                file.write(f"(actor_location a{actor_id} n{actor_node})")
                file.write(newline())

            file.write(newline())
            file.write(tab() + ";; setting the connection between each nodes" + newline())
            for edge in world_info['edges'].values():
                node_A = str(edge['node_a'])
                node_B = str(edge['node_b'])
                edge_length = str(edge['length'])

                file.write(tab() + f"(connected n{node_A} n{node_B})")
                file.write(tab() + f"(connected n{node_B} n{node_A})")
                file.write(newline())

                file.write(tab() + f"(= (edge_length n{node_A} n{node_B}) {edge_length})" + newline())
                file.write(tab() + f"(= (edge_length n{node_B} n{node_A}) {edge_length})" + newline())
            file.write(newline())

            file.write(tab() + ";; setting the mines details" + newline())
            for mine in world_info['mines'].values():
                mine_id = str(mine['id'])
                mine_node = str(mine['node'])
                mine_color = PDDLInterface.COLOURS[mine['colour']]
                file.write(tab() + f"(mine_detail m{mine_id} n{mine_node} {mine_color})" + newline())
            file.write(newline())

            # set the variables create_site, not_created_site, carrying, not_carrying, deposited, not_deposited
            file.write(newline())
            for task in world_info['tasks'].values():
                if not world_info['tasks'][task['id']]['completed']:
                    for actor in world_info['actors'].values():      
                        for idx, j in enumerate(PDDLInterface.COLOURS):
                            file.write(tab())
                            file.write('(not (carrying a' + str(actor['id']) + space() + str(j) + '))' + newline())
                            file.write(tab())
                            file.write('(not_carrying a' + str(actor['id']) + space() + str(j) + ')' + newline())
                        file.write(newline())
                    break

            for task in world_info['tasks'].values():
                if not world_info['tasks'][task['id']]['completed']:
                    for actor in world_info['actors'].values():
                        for idx, j in enumerate(PDDLInterface.COLOURS):
                            file.write(tab())
                            file.write('(not (deposited a' + str(actor['id']) + space() + str(j) + space() + 'n' + str(task['node']) + '))' + newline())
                            file.write(tab())
                            file.write('(not_deposited a' + str(actor['id']) + space() + str(j) + space() + 'n' + str(task['node']) + ')' + newline())
                            # break
                        file.write(newline())
                        # break
                    break
                        
            for task in world_info['tasks'].values():
                if not world_info['tasks'][task['id']]['completed']:
                    file.write(tab())
                    file.write(f"(not (create_site n{str(task['node'])}))" + newline())
                    file.write(tab())
                    file.write(f"(not_created_site n{str(task['node'])})" + newline())
                    break

            for task in world_info['tasks'].values():
                if not world_info['tasks'][task['id']]['completed']:
                    for idx, j in enumerate(PDDLInterface.COLOURS):
                        num_needed = task['needed_resources'][idx]
                        if num_needed > 0:
                            file.write(tab())
                            file.write(f"(= (color_count {str(j)} n{str(task['node'])}) {str(num_needed)})" + newline())
                            # break
                        # break
                    break

            for actor in world_info['actors'].values():
                for actor2 in world_info['actors'].values():
                    if actor['id'] != actor2['id']:
                        file.write(tab())
                        file.write(f"(not-same a{str(actor['id'])} a{str(actor2['id'])})" + newline())
                        file.write(tab())
                        file.write(f"(not-same a{str(actor2['id'])} a{str(actor['id'])})" + newline())
                    else:
                        file.write(tab())
                        file.write(f"(not (not-same a{str(actor['id'])} a{str(actor2['id'])}))" + newline())

            # blue resource takes twice as long to mine
            blue_resource = PDDLInterface.COLOURS.index('blue')
            orange_resource = PDDLInterface.COLOURS.index('orange')
            for mine in world_info['mines'].values():
                color_id = mine['colour']
                if color_id == blue_resource:
                    file.write(tab())
                    file.write(f"(= (mine_duration_blue m{str(mine['id'])}) {str(33 * 2)})" + newline())
                elif color_id == orange_resource:
                    file.write(tab())
                    file.write(f"(= (mine_duration_orange m{str(mine['id'])}) {str(33)})" + newline())
                else:
                    file.write(tab())
                    file.write(f"(= (mine_duration m{str(mine['id'])}) {str(33)})" + newline())

            for colour in PDDLInterface.COLOURS:
                if colour == 'orange':
                    file.write(tab() + f"(is_orange {str(colour)})" + newline())
                    file.write(tab() + f"(not_blue {str(colour)})" + newline())
                    file.write(tab() + f"(not_red {str(colour)})" + newline())
                    file.write(tab() + f"(not_black {str(colour)})" + newline())
                elif colour == 'blue':
                    file.write(tab() + f"(is_blue {str(colour)})" + newline())
                    file.write(tab() + f"(not_orange {str(colour)})" + newline())
                    file.write(tab() + f"(not_black {str(colour)})" + newline())
                    file.write(tab() + f"(not_red {str(colour)})" + newline())
                elif colour == 'black':
                    file.write(tab() + f"(is_black {str(colour)})" + newline())
                    file.write(tab() + f"(not_orange {str(colour)})" + newline())
                    file.write(tab() + f"(not_blue {str(colour)})" + newline())
                    file.write(tab() + f"(not_red {str(colour)})" + newline())
                elif colour == 'red':
                    file.write(tab() + f"(is_red {str(colour)})" + newline())
                    file.write(tab() + f"(not_orange {str(colour)})" + newline())
                    file.write(tab() + f"(not_blue {str(colour)})" + newline())
                    file.write(tab() + f"(not_black {str(colour)})" + newline())
                else:
                    file.write(tab() + f"(not_black {str(colour)})" + newline())
                    file.write(tab() + f"(not_orange {str(colour)})" + newline())
                    file.write(tab() + f"(not_blue {str(colour)})" + newline())
                    file.write(tab() + f"(not_red {str(colour)})" + newline())

            # actor move speed
            for actor in world_info['actors'].values():
                file.write(tab())
                file.write(f"(= (move_speed a{str(actor['id'])}) 5)" + newline())

            for i in range(0, 6000, 1200):
                file.write(tab())
                file.write(f"(at {str(i)} (red_available))" + newline())

            for actor in world_info['actors'].values():
                file.write(tab())
                file.write(f"(not_resource_carrying a{str(actor['id'])})" + newline())

            file.write(')')
            file.write(newline())

        ######################################################## GOAL ########################################################

            file.write("(:goal" + newline())
            file.write(tab() + '(and' + newline())

            # fetch the tasks from the world info
            for task in world_info['tasks'].values():
                if not world_info['tasks'][task['id']]['completed']:
                    for idx, j in enumerate(PDDLInterface.COLOURS):
                        num_needed = task['needed_resources'][idx]
                        if num_needed > 0:
                            file.write(tab() + tab())
                            file.write('(= (color_count' + space() + str(j) + space() + 'n' + str(task['node']) + ')' + space() + str(0) + ')' + newline())
                            # break
                        # break
                    break

            file.write(")))" + newline())
            file.close()

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
        response = str(subprocess.run([f'{optic_path}', '-N', f'{domain}', f'{problem}'], stdout=subprocess.PIPE))
        start_index = response.rindex('Solution Found')

        if start_index == -1:
            return False

        trimmed_plan = response[start_index:-2]
        trimmed_response_list = trimmed_plan.split('\\n')[4:]
        transformed_string = '\n'.join(list(filter(lambda x: x != "", trimmed_response_list)))

        with open(plan, "w") as file:
            file.write(transformed_string)

        return True

if __name__ == '__main__':
    PDDLInterface.generatePlan("agents/domain-craft-bots-temporal.pddl", "agents/problem-temporal.pddl", "agents/plan-temporal.pddl", verbose=True)
    plan = PDDLInterface.readPDDLPlan('agents/plan-temporal.pddl')
    print(plan)