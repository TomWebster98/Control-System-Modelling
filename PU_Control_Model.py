class PowerUnitModel:
    """
    A class to model the behaviour of the Power Unit.

    ...

    Attributes
    ----------
    Mode Number : int
        Number corresponding to a PU mode.

    Methods
    -------
    set_mode(self, new_mode):
        Sets the Power Unit mode to new_mode.

    get_mode(self):
        Returns the current Power Unit mode.

    """

    def __init__(self, mode_number=1):
        self._mode = mode_number

    def set_mode(self, new_mode):
        """
        Sets the Power Unit mode to new_mode.  
        """
        self._mode = new_mode

    def get_mode(self):
        """
        Returns the current Power Unit mode.
        """
        return self._mode


MODES = {

    1: "Pit Lane",
    2: "Out Lap",
    3: "In Lap",
    4: "Hotlap",
    5: "Race Start",
    6: "Fuel Save",
    7: "Energy Harvest",
    8: "Overtake",
    9: "Safety Car",
    10: "VSC",
    11: "Wet",
    12: "Intermediate",
    13: "Fault"

}


class CommandLine:
    """
    A class to model the command line interface.

    ...

    Attributes
    ----------
    pu : 
        Instance of PowerUnitModel.

    Methods
    -------
    menu(self):
        Prints the full list of Power Unit modes from the MODES dictionary as well as the current mode.

    choose_mode(self, pu, mode_str):
        Handles mode input from user as an integer and sets the mode accordingly, raising exceptions for invalid inputs.

    userinput(self, callback):
        Handles looping for repeated user inputs and functionality for exiting the program.

    """

    def __init__(self, pu):
        self.pu = pu

    def menu(self, pu):
        """
        Prints the full list of Power Unit modes from the MODES dictionary as well as the current mode.
        """
        print()
        print("Enter PU Mode Number")
        print("-------------------------------")
        for x in MODES:
            print(f"{x} : {MODES.get(x)}")
        print("X : Shutdown")
        print()
        print(
            f"Current Mode: {pu.get_mode()}, {MODES.get(pu.get_mode())}")
        print("-------------------------------")

    def choose_mode(self, mode_str):
        """
        Handles mode input from user as an integer and sets the mode accordingly, raising exceptions for invalid inputs.
        """
        try:
            mode = int(mode_str) if mode_str else 3
            if mode not in MODES.keys():
                raise ValueError
        except ValueError:
            print()
            print(
                "Error: invalid mode number. Please enter a valid mode from the list provided.")
        else:
            self.pu.set_mode(mode)

    def userinput(self):
        """
        Handles looping for repeated user inputs to change through modes and functionality for PU shutdown.
        """
        running = True
        while (running):
            self.menu(pu)
            mode_str = input("PU Mode Number: ")
            mode_str = mode_str.strip()
            if mode_str == "X" or mode_str == "x":
                print()
                print("Finished")
                print()
                running = False
            else:
                self.choose_mode(mode_str)


if __name__ == '__main__':
    pu = PowerUnitModel()
    cmd = CommandLine(pu)
    cmd.userinput()
