class Logger:

    world = None
    log_to_screen = True
    log_to_file = False
    log_file = None
    log = []

    @staticmethod
    def setup_logger(config, world):
        total_number_of_mines = 5
        Logger.world = world
        # Logger.log.clear()
        if config['Run Configuration']['log_to_file']['value']:
            Logger.log_to_file = True
            Logger.log_file = config['Run Configuration']['log_file_path']['value']
            with open(Logger.log_file, 'w') as log:
                log.write("(logger) begin log \n")
                if Logger.world == None: return

                log.write(f'Last ID == {world.last_id} \n')
                for i in range( (world.last_id + 1) - total_number_of_mines):
                    log.write(f'{i}--{world.get_by_id(i)} \n')
                log.write(f'{(world.last_id + 1) - total_number_of_mines} to {world.last_id} are mines: [red, blue, orange, black and green] \n')


    @staticmethod
    def info(sender: str, message: str):
        if Logger.world == None: return
        time = Logger.world.tick
        Logger.log.append((time, sender, message))
        msg = "[" + str(time) + "] " + "(" + sender + ") " + message
        if Logger.log_to_file:
            with open(Logger.log_file, 'a') as log:
                log.write(msg + "\n")
        if Logger.log_to_screen:
            print(msg)

    @staticmethod
    def error(sender: str, message: str):
        if Logger.world == None: return
        time = Logger.world.tick
        Logger.log.append((time, sender, message))
        msg = "[" + str(time) + "] " + "(" + sender + ") " + message
        if Logger.log_to_file:
            with open(Logger.log_file, 'a') as log:
                log.write(msg + "\n")
        if Logger.log_to_screen:
            print(msg)