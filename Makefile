NOMBRE="blockly-package"
VERSION=$(shell git describe --abbrev=0 --tags)

N=[0m
G=[01;32m
Y=[01;33m
B=[01;34m
L=[01;30m

comandos:
	@echo ""
	@echo "${B}Comandos disponibles para ${G}${NOMBRE}${N} - ${Y} versión ${VERSION}${N}"
	@echo ""
	@echo "  ${Y}Para desarrolladores (en orden)${N}"
	@echo ""
	@echo "    ${G}iniciar${N}         Instala todas las dependencias."
	@echo "    ${G}actualizar${N}      Actualiza la versión de blockly desde el repositorio."
	@echo "    ${G}commit${N}          Commitea los cambios actuales (de la actualizacion)."
	@echo "    ${G}version${N}         Incrementa la versión y publica el paquete."
	@echo ""
	@echo ""

iniciar:
	@echo "${G}instalando dependencias...${N}"
	git submodule update --init

blockly: iniciar

version: blockly
	@echo "${G}generando una versión nueva...${N}"
	npm version patch
	git push --all
	git push --tags

actualizar: blockly registrarActualizacion
	@echo "${G}actualizando blockly a la última versión...${N}"
	git submodule update --remote --merge
	make copiarArchivos

copiarArchivos:
	cp blockly/blockly_compressed.js ./
	cp blockly/blockly_uncompressed.js ./
	cp blockly/blocks_compressed.js ./
	cp blockly/msg/js/es.js ./
	cp blockly/javascript_compressed.js ./
	cp -R blockly/media ./

commit:
	git commit -am "Actualizando blockly a versión de $(shell cd blockly; git log -1 --date=short --pretty=format:%cd)"

registrarActualizacion:
	echo "$(shell date +%Y-%m-%d) - $(NOMBRE) - Blockly commit SHA: $(shell cd blockly; git rev-parse HEAD) - Blockly commit date: $(shell cd blockly; git log -1 --date=short --pretty=format:%cd)" >> versionNotes.txt