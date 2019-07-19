NAME="blockly-package"
VERSION=$(shell git describe --abbrev=0 --tags)

N=[0m
G=[01;32m
Y=[01;33m
B=[01;34m
L=[01;30m

commands:
	@echo ""
	@echo "${G}${NAME}${N} - ${Y} version ${VERSION}${N}"
	@echo ""
	@echo "    ${G}initial_blockly${N}   Clones blockly from this project's last release"
	@echo "    ${G}latest_blockly${N}    Updates blockly to its latest release"
	@echo ""
	@echo "${G}What you will normally want to do, in order:${N}"
	@echo "    ${G}update${N}            Updates blockly & copies correspondant files"
	@echo "    ${G}release${N}           Publishes new version, logging date"
	@echo ""

initial_blockly:
	@echo "${G}Cloning Blockly used for this project's last release...${N}"
	git submodule update --init

latest_blockly:
	@echo "${G}Updating Blockly to its very last version...${N}"
	git submodule update --remote --merge

copy:
	cp blockly/blockly_compressed.js ./
	cp blockly/blockly_uncompressed.js ./
	cp blockly/blocks_compressed.js ./
	cp blockly/msg/js/es.js ./
	cp blockly/javascript_compressed.js ./
	cp -R blockly/media ./

commit:
	git commit -am "Updating blockly to version from $(shell cd blockly; git log -1 --date=short --pretty=format:%cd)"

register_update:
	echo "$(shell date +%Y-%m-%d) - $(NAME) - Blockly commit SHA: $(shell cd blockly; git rev-parse HEAD) - Blockly commit date: $(shell cd blockly; git log -1 --date=short --pretty=format:%cd)" >> versionNotes.txt

update: initial_blockly latest_blockly copy 

release: register_update commit
	@echo "${G}Publishing new version${N}"
	npm version patch
	git push --all
	git push --tags