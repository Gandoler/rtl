# Отчет по изучению линтера  `Synopsys Spyglass`

первый запуск после редактирования мейкфайла

```makefile
SHELL                   := /bin/bash

## set before use
#export TOP_MODULE=GSIM
export TOP_MODULE=sp_8192x8_nm
export TOP_DIR=$(shell pwd)
export LINT_DIR=$(TOP_DIR)/lint/spyglass

### directories ###
export SOURCE_DIR=$(TOP_DIR)/rtl/test_folde
export ADD_DIR=$(TOP_DIR)/submodules
export SDC_PATH=$(TOP_DIR)/sdc
export RTL_PATH=$(SOURCE_DIR) $(ADD_DIR)
export RTL_SRC=$(wildcard $(shell find $(RTL_PATH) -type f \( -iname \*.h -o -iname \*.vh -o -iname \*.svh -o -iname \*.sv -o -iname \*.v -o -iname \*.vhdl \)))
export INCLUDE_DIRS=$(wildcard $(shell find $(RTL_PATH) -type d -iname \* ))
#export SCRIPTS_DIR=$(TOP_DIR)/spyglass/scripts
export PROJECT_DIR=$(LINT_DIR)/reports/${TOP_MODULE}_WORK
export RTL_TYPE=SIMPLE


.PHONY: lint lint_clean

lint_simple:
	$(LINT_DIR)/run_spyglass.sh simple
lint_full:
	$(LINT_DIR)/run_spyglass.sh full
	@echo "Fatal Error missed  license features: lint_func Auto_Verify dashboard"
lint_clean:
	$(LINT_DIR)/run_spyglass.sh clean
```

![](./pic/first_start.png)



## Интересные моменты полученные от линтера
