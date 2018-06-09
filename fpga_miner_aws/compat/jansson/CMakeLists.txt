
include_directories(${PROJECT_SOURCE_DIR}/compat/jansson)

add_library(jansson dump.c
			  hashtable.c
			  load.c
			  strbuffer.c
			  utf.c
			  value.c)