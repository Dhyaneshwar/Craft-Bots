import argparse
from agents.rule_based_agent import RBAgent
from agents.assignment_Agent import Assignment_Agent
from craftbots.simulation import Simulation
from gui.main_window import CraftBotsGUI

if __name__ == '__main__':

    # parse command line arguments
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument('-f', help="configuration file", type=str, default='craftbots/config/simple_configuration.yaml')

    #  changing the configuration file name
    # arg_parser.add_argument('-f', help="configuration file", type=str, default='craftbots/config/2023part1_configuration.yaml')

    args = arg_parser.parse_args()

    # Simulation
    sim = Simulation(configuration_file=args.f)

    # agent
    # agent = RBAgent()

    agent = Assignment_Agent()
    sim.agents.append(agent)

    # GUI
    gui = CraftBotsGUI(sim)
    gui.start_window()

