
SHELL:=bash

GREEN:=\033[32m
NC:=\033[0m
### 

help:
	-@(pandoc README.md | lynx -dump -stdin)
	-@(echo "")
	-@(echo "Usage:")
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-30s$(NC) %s\n", $$1, $$2}'

###


requirements.txt: venv
update-requirements: ## Update requirements.txt.
update-requirements: venv
	@(echo "Updating requirements ..." \
	&& . venv/bin/activate \
	&& pip freeze > requirements.txt \
	)	

venv:
	make venv-install
venv-install: ## Setup using python venv.
venv-install:
	(echo "Setup venv ..." \
	&& test -d venv || python3.9 -m venv venv \
	&& . venv/bin/activate \
	&& pip install -r requirements.txt \
	)

install-githooks: # Install githooks for deck_of_cards
install-githooks:
	(. venv/bin/activate \
	&& nbdev_install_git_hooks \
	)

venv-start-nb: ## Start Jupyter Notebook with venv.
venv-start-nb:
	-@(echo "Starting Jupyter Notebook ..." \
	&& . venv/bin/activate \
	&& export DEV_DWH_BQ_IMMO=1 \
	&& jupyter notebook --no-browser \
	)

venv-start-lab: ## Start Jupyter Notebook with venv.
venv-start-lab:
	-@(echo "Starting Jupyter Lab ..." \
	&& . venv/bin/activate \
	&& export DEV_DWH_BQ_IMMO=1 \
	&& jupyter lab --no-browser \
	)


venv-build-lib: ## Build lib with nbdev.
venv-build-lib:
	(export DEV_DWH_BQ_IMMO=0 \
	&& . venv/bin/activate && nbdev_build_lib \
	)	

venv-build-docs: ## Build docs with nbdev.
venv-build-docs:
	. venv/bin/activate && nbdev_build_docs

venv-run-test: ## Run tests using nbdev.
venv-run-test:
	(. venv/bin/activate \
	&& export DEV_DWH_BQ_IMMO=0 \
	&& nbdev_test_nbs \
	)

venv-run-test-slow: ## Run slow tests using nbdev.
venv-run-test-slow:
	(. venv/bin/activate \
	&& export DEV_DWH_BQ_IMMO=0 \
	&& nbdev_test_nbs --timing --flags slow\
	)


serving-docs: ## Serving documentation.
serving-docs:
	cd docs && bundle exec jekyll serve --livereload

clean: ## Clean current directory.
clean:
	rm -rf venv

