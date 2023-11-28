# LEG to ARM Converter
converter.py converts LEGv8 assembly from the Computer Organization and Design ARM Edition textbook to runnable ARMv8 assembly. It also includes two bash scripts, one for running LEG and another for running ARM.

## Ways To Run
### 1. Run LEG

The run_leg.sh script takes a LEG file as its input, converts it to ARM, and then runs it. It is used like:

    Usage: run_leg.sh [-hd] [LEG file]
    -h: Display help
    -d: Enter debug mode
    [LEG file]: .s file

The cleanup of run_leg.sh includes deleting the created ARM file. For run_leg.sh to work, run_leg.sh and converter.py must be in the same folder. Debug mode runs the code in gdb.

### 2. Convert LEG to ARM and then run ARM
This way of running takes two steps and lets you see the resulting ARM file. The first command is to run the converter.py script, which is used like:

    python3 converter.py <LEG input> <ARM output>

Then you can run the resulting ARM file using the run_arm.sh file which is used like:

    Usage: run_arm.sh [-hd] [LEG file]
    -h: Display help
    -d: Enter debug mode
    [ARM file]: .s file

This will run your ARM and clean itself up afterward. Debug mode runs the code in gdb.


## Common Issues
### Permission Denied

If for any script you get a permission denied message, simply run 

    chmod +x <script> 
