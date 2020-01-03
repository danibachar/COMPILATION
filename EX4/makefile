###############
# DIRECTORIES #
###############
BASEDIR           = $(shell pwd)
JFlex_DIR         = ${BASEDIR}/FOLDER_0_JFlex
CUP_DIR           = ${BASEDIR}/FOLDER_1_CUP
SRC_DIR           = ${BASEDIR}/FOLDER_2_SRC
BIN_DIR           = ${BASEDIR}/FOLDER_3_BIN
INPUT_DIR         = ${BASEDIR}/FOLDER_4_INPUT
OUTPUT_DIR        = ${BASEDIR}/FOLDER_5_OUTPUT
EXP_OUTPUT_DIR    = ${BASEDIR}/FOLDER_6_EXPECTED_OUTPUT
EXTERNAL_JARS_DIR = ${BASEDIR}/FOLDER_7_EXTERNAL_JARS
MANIFEST_DIR      = ${BASEDIR}/FOLDER_8_MANIFEST

#########
# FILES #
#########
JFlex_GENERATED_FILE      = ${SRC_DIR}/Lexer.java
CUP_GENERATED_FILES       = ${SRC_DIR}/Parser.java ${SRC_DIR}/TokenNames.java
JFlex_CUP_GENERATED_FILES = ${JFlex_GENERATED_FILE} ${CUP_GENERATED_FILES}
SRC_FILES                 = ${SRC_DIR}/*.java              \
                            ${SRC_DIR}/IR/*.java           \
                            ${SRC_DIR}/AST/*.java          \
                            ${SRC_DIR}/TEMP/*.java         \
                            ${SRC_DIR}/LLVM/*.java         \
                            ${SRC_DIR}/MIPS/*.java         \
                            ${SRC_DIR}/TYPES/*.java        \
                            ${SRC_DIR}/SYMBOL_TABLE/*.java
EXTERNAL_JAR_FILES        = ${EXTERNAL_JARS_DIR}/java-cup-11b-runtime.jar
MANIFEST_FILE             = ${MANIFEST_DIR}/MANIFEST.MF

########################
# DEFINITIONS :: JFlex #
########################
JFlex_PROGRAM  = jflex
JFlex_FLAGS    = -q
JFlex_DEST_DIR = ${SRC_DIR}
JFlex_FILE     = ${JFlex_DIR}/LEX_FILE.lex

######################
# DEFINITIONS :: CUP #
######################
CUP_PROGRAM                    = java -jar ${EXTERNAL_JARS_DIR}/java-cup-11b.jar
CUP_FILE                       = ${CUP_DIR}/CUP_FILE.cup
CUP_GENERATED_PARSER_NAME      = Parser
CUP_GENERATED_SYMBOLS_FILENAME = TokenNames

######################
# DEFINITIONS :: CUP #
######################
CUP_FLAGS =                                \
-nowarn                                    \
-parser  ${CUP_GENERATED_PARSER_NAME}      \
-symbols ${CUP_GENERATED_SYMBOLS_FILENAME}

#########################
# DEFINITIONS :: PARSER #
#########################
INPUT    = ${INPUT_DIR}/Input.txt
OUTPUT   = ${OUTPUT_DIR}/SemanticStatus.txt

##########
# TARGET #
##########
compile:
	clear
	@echo "*******************************"
	@echo "*                             *"
	@echo "*                             *"
	@echo "* [0] Remove COMPILER program *"
	@echo "*                             *"
	@echo "*                             *"
	@echo "*******************************"
	rm -rf COMPILER
	@echo "\n"
	@echo "************************************************************"
	@echo "*                                                          *"
	@echo "*                                                          *"
	@echo "* [1] Remove *.class files and JFlex-CUP generated files:  *"
	@echo "*                                                          *"
	@echo "*     Lexer.java                                           *"
	@echo "*     Parser.java                                          *"
	@echo "*     TokenNames.java                                      *"
	@echo "*                                                          *"
	@echo "************************************************************"
	rm -rf ${JFlex_CUP_GENERATED_FILES} ${BIN_DIR}/*.class ${BIN_DIR}/AST/*.class
	@echo "\n"
	@echo "************************************************************"
	@echo "*                                                          *"
	@echo "*                                                          *"
	@echo "* [2] Use JFlex to synthesize Lexer.java from LEX_FILE.lex *"
	@echo "*                                                          *"
	@echo "*                                                          *"
	@echo "************************************************************"
	$(JFlex_PROGRAM) ${JFlex_FLAGS} -d ${JFlex_DEST_DIR} ${JFlex_FILE}
	@echo "\n"
	@echo "*******************************************************************************"
	@echo "*                                                                             *"
	@echo "*                                                                             *"
	@echo "* [3] Use CUP to synthesize Parser.java and TokenNames.java from CUP_FILE.cup *"
	@echo "*                                                                             *"
	@echo "*                                                                             *"
	@echo "*******************************************************************************"
	$(CUP_PROGRAM) ${CUP_FLAGS} -destdir ${SRC_DIR} ${CUP_FILE}
	@echo "\n"
	@echo "********************************************************"
	@echo "*                                                      *"
	@echo "*                                                      *"
	@echo "* [4] Create *.class files from *.java files + CUP JAR *"
	@echo "*                                                      *"
	@echo "*                                                      *"
	@echo "********************************************************"
	javac -cp ${EXTERNAL_JAR_FILES} -d ${BIN_DIR} ${SRC_FILES}
	@echo "\n"
	@echo "***********************************************************"
	@echo "*                                                         *"
	@echo "*                                                         *"
	@echo "* [5] Create a JAR file from from *.class files + CUP JAR *"
	@echo "*                                                         *"
	@echo "*                                                         *"
	@echo "***********************************************************"
	jar cfm COMPILER ${MANIFEST_FILE} -C ${BIN_DIR} .

everything:
	clear
	@echo "******************************"
	@echo "*                            *"
	@echo "*                            *"
	@echo "* [0] Remove COMPIER program *"
	@echo "*                            *"
	@echo "*                            *"
	@echo "******************************"
	rm -rf COMPILER
	@echo "\n"
	@echo "************************************************************"
	@echo "*                                                          *"
	@echo "*                                                          *"
	@echo "* [1] Remove *.class files and JFlex-CUP generated files:  *"
	@echo "*                                                          *"
	@echo "*     Lexer.java                                           *"
	@echo "*     Parser.java                                          *"
	@echo "*     TokenNames.java                                      *"
	@echo "*                                                          *"
	@echo "************************************************************"
	rm -rf ${JFlex_CUP_GENERATED_FILES} ${BIN_DIR}/*.class ${BIN_DIR}/AST/*.class
	@echo "\n"
	@echo "************************************************************"
	@echo "*                                                          *"
	@echo "*                                                          *"
	@echo "* [2] Use JFlex to synthesize Lexer.java from LEX_FILE.lex *"
	@echo "*                                                          *"
	@echo "*                                                          *"
	@echo "************************************************************"
	$(JFlex_PROGRAM) ${JFlex_FLAGS} -d ${JFlex_DEST_DIR} ${JFlex_FILE}
	@echo "\n"
	@echo "*******************************************************************************"
	@echo "*                                                                             *"
	@echo "*                                                                             *"
	@echo "* [3] Use CUP to synthesize Parser.java and TokenNames.java from CUP_FILE.cup *"
	@echo "*                                                                             *"
	@echo "*                                                                             *"
	@echo "*******************************************************************************"
	$(CUP_PROGRAM) ${CUP_FLAGS} -destdir ${SRC_DIR} ${CUP_FILE}
	@echo "\n"
	@echo "********************************************************"
	@echo "*                                                      *"
	@echo "*                                                      *"
	@echo "* [4] Create *.class files from *.java files + CUP JAR *"
	@echo "*                                                      *"
	@echo "*                                                      *"
	@echo "********************************************************"
	javac -cp ${EXTERNAL_JAR_FILES} -d ${BIN_DIR} ${SRC_FILES}
	@echo "\n"
	@echo "***********************************************************"
	@echo "*                                                         *"
	@echo "*                                                         *"
	@echo "* [5] Create a JAR file from from *.class files + CUP JAR *"
	@echo "*                                                         *"
	@echo "*                                                         *"
	@echo "***********************************************************"
	jar cfm COMPILER ${MANIFEST_FILE} -C ${BIN_DIR} .
	@echo "\n"
	@echo "*****************************"
	@echo "*                           *"
	@echo "*                           *"
	@echo "* [6] Run resulting program *"
	@echo "*                           *"
	@echo "*                           *"
	@echo "*****************************"
	java -jar COMPILER ${INPUT} ${OUTPUT}
	@echo "\n"
	@echo "***************************************"
	@echo "*                                     *"
	@echo "*                                     *"
	@echo "* [7] Create a jpeg AST visualization *"
	@echo "*                                     *"
	@echo "*                                     *"
	@echo "***************************************"
	dot -Tjpeg -o${OUTPUT_DIR}/AST.jpeg ${OUTPUT_DIR}/AST_IN_GRAPHVIZ_DOT_FORMAT.txt
	@echo "\n"
	@echo "************************************************"
	@echo "*                                              *"
	@echo "*                                              *"
	@echo "* [8] Open the jpeg AST visualization with eog *"
	@echo "*                                              *"
	@echo "*                                              *"
	@echo "************************************************"
	eog ${OUTPUT_DIR}/AST.jpeg &
	@echo "\n"
	@echo "******************************"
	@echo "*                            *"
	@echo "*                            *"
	@echo "* [9] transform *.ll -> *.bc *"
	@echo "*                            *"
	@echo "*                            *"
	@echo "******************************"
	llvm-as ${OUTPUT_DIR}/LLVM_bitcode.ll
	@echo "\n"
	@echo "*************************************"
	@echo "*                                   *"
	@echo "*                                   *"
	@echo "* [10] transform *.bc -> executable *"
	@echo "*                                   *"
	@echo "*                                   *"
	@echo "*************************************"
	clang -Wno-override-module ${OUTPUT_DIR}/LLVM_bitcode.bc -o ${BASEDIR}/program
	@echo "\n"
	@echo "********************"
	@echo "*                  *"
	@echo "*                  *"
	@echo "* [11] run program *"
	@echo "*                  *"
	@echo "*                  *"
	@echo "********************"
	${BASEDIR}/program
	@echo "\n"
	@echo "****************************************************"
	@echo "*                                                  *"
	@echo "*                                                  *"
	@echo "* [12] generate graphviz dot representation of CFG *"
	@echo "*                                                  *"
	@echo "*                                                  *"
	@echo "****************************************************"
	opt -dot-cfg ${OUTPUT_DIR}/LLVM_bitcode.bc 1>/dev/null 2>/dev/null
	dot -Tjpeg -o${OUTPUT_DIR}/CFG.jpeg .main.dot
	eog ${OUTPUT_DIR}/CFG.jpeg &
run-old:
	# Will create the *.ll file from source code
	java -jar COMPILER ${INPUT_DIR}/$(INPUT_FILE).txt ${OUTPUT_DIR}/$(OUTPUT_FILE).ll
	# Will convert the *.ll file to *.bc file
	llvm-as ${OUTPUT_DIR}/$(OUTPUT_FILE).ll
	# PROGRAM = ${BASEDIR}/${OUTPUT_DIR}/$(OUTPUT_FILE)
	# Will compile the actual program with the name of the output file
	# clang -Wno-override-module ${OUTPUT_DIR}/LLVM_bitcode.bc -o ${BASEDIR}/program

	clang -Wno-override-module ${OUTPUT_DIR}/$(OUTPUT_FILE).bc -o ${BASEDIR}/program
	# Will run the program and create an output file to compare with the expected
	${BASEDIR}/program > ${OUTPUT_DIR}/$(OUTPUT_FILE).txt
	# ${BASEDIR}/${OUTPUT_DIR}/program > ${EXP_OUTPUT_DIR}/$(OUTPUT_FILE)_EXPECTED_OUTPUT.txt
run:
	# Will create the *.ll file from source code
	java -jar COMPILER $(INPUT_FILE) $(OUTPUT_FILE).ll
	# Will convert the *.ll file to *.bc file
	llvm-as $(OUTPUT_FILE).ll
	# Will compile the actual program with the name of the output file
	clang -Wno-override-module $(OUTPUT_FILE).bc -o $(OUTPUT_FILE).prog
	# Will run the program and create an output file to compare with the expected
	$(OUTPUT_FILE).prog > $(OUTPUT_FILE)
	# ${BASEDIR}/${OUTPUT_DIR}/program > ${EXP_OUTPUT_DIR}/$(OUTPUT_FILE)_EXPECTED_OUTPUT.txt
