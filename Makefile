all:
	@echo "Falta especificar el comando."

iniciar:
	git submodule update --init
	
version:
	npm version patch
	git push --all
	git push --tags

actualizar:
	git submodule update --remote --merge


