# bash CLI template to build bash CLI

## how to use

### clone the repository
```bash
git clone https://github.com/shakibamoshiri/bash-CLI-template.git
cd bash-CLI-template
```

### run ./cli.sh
```bash
./cli
```

### modify according to your needs
Core parts:

 - variables for echo options
    - `_os_flag`
    - `_os_args`
    - etc
 - helper functions, show / print to users
    - `_help`
    - `_os_help`
 - check functions: to check the arguments, safety checks
    - `_os_check`
    - etc

You can modify these parts and customize it.
