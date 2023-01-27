SHELL=/usr/bin/env bash
.SHELLFLAGS=-euc

.PHONY: all
all: public/

# zola can be installed with 'cargo install zola'
public/: popi_config.toml content/blog/*
	zola -c popi_config.toml build

# need to move to not break links
public/*_images:
	mv public/blog/*_images/ public/

.PHONY: update_popi.tech
update_popi.tech: public/ public/*_images
	command -v rsync &>/dev/null && rsync -avz public/* popi@popi.tech:/opt/blog/ \
	|| scp -r public/* popi@popi.tech:/opt/blog/

.PHONY: clean
clean:
	$(RM) -r public/
