#################################################################################
# GLOBALS                                                                       #
#################################################################################

PROJECT_NAME = chustomer-churn
PYTHON_VERSION = 3.12
PYTHON_INTERPRETER = python

#################################################################################
# COMMANDS                                                                      #
#################################################################################


## Install Python Dependencies
.PHONY: requirements
requirements:
	$(PYTHON_INTERPRETER) -m pip install -U pip
	$(PYTHON_INTERPRETER) -m pip install -r requirements.txt
	



## Delete all compiled Python files
.PHONY: clean
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete

## Lint using flake8 and black (use `make format` to do formatting)
.PHONY: lint
lint:
	flake8 prediction
	isort --check --diff --profile black prediction
	black --check --config pyproject.toml prediction

## Format source code with black
.PHONY: format
format:
	black --config pyproject.toml prediction


## Download Data from storage system
.PHONY: sync_data_down
sync_data_down:
	az storage blob download-batch -s aws-1/data/ \
		-d data/
	

## Upload Data to storage system
.PHONY: sync_data_up
sync_data_up:
	az storage blob upload-batch -d aws-1/data/ \
		-s data/
	



## Set up python interpreter environment
.PHONY: create_environment
create_environment:
	pipenv --python $(PYTHON_VERSION)
	@echo ">>> New pipenv created. Activate with:\npipenv shell"
	



#################################################################################
# PROJECT RULES                                                                 #
#################################################################################



#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

define PRINT_HELP_PYSCRIPT
import re, sys; \
lines = '\n'.join([line for line in sys.stdin]); \
matches = re.findall(r'\n## (.*)\n[\s\S]+?\n([a-zA-Z_-]+):', lines); \
print('Available rules:\n'); \
print('\n'.join(['{:25}{}'.format(*reversed(match)) for match in matches]))
endef
export PRINT_HELP_PYSCRIPT

help:
	@$(PYTHON_INTERPRETER) -c "${PRINT_HELP_PYSCRIPT}" < $(MAKEFILE_LIST)
