#!/usr/bin/python3

import unittest
import filecmp
import time, os, subprocess, sys, argparse

INPUT_PATH = "FOLDER_4_INPUT"

OUTPUT_PATH = "FOLDER_5_OUTPUT"
EXPECTED_PATH = "FOLDER_6_EXPECTED_OUTPUT"

def ensure_path(path):
    directory = "/".join(path.split("/")[0:-1])
    if not os.path.exists(directory):
        os.makedirs(directory)

class TestSequense(unittest.TestCase):
    pass


def test_generator(input_file, output_file, compare_file):
    def _run_command(command,log_command=False):
        if log_command:
            print("\n\nRunnig Command {}\n\n".format(command))
        process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if process.stdout != None:
            for line in process.stdout:
        	    print(line)
        if process.stderr != None:
            for line in process.stderr:
        	    print(line)
        status = process.wait()
        if status != 0:
            print("Fail running {}, stderr {},stdout {}".format(command, process.stderr, process.stdout))

    def test(self):

        # print("\ninput = {} \noutput = {} \ncompare = {}\n".format(input_file, output_file, compare_file))

        ensure_path(input_file)
        ensure_path(output_file)

        _run_command("make run INPUT_FILE='{input}' OUTPUT_FILE='{output}'".format(input=input_file, output=output_file),True)

        ensure_path(compare_file)
        if os.path.exists(compare_file) and os.path.exists(output_file):
            if not filecmp.cmp(output_file, compare_file):
                # print("\n\n####{} - output file not as expected####\n\n".format(output_file))
                print("\nexpected output\n".format(output_file))
                _run_command("cat {output}".format(output=compare_file))
                print("\nactual output\n".format(output_file))
                _run_command("cat {output}".format(output=output_file))

    return test


def _full_name(name):
    return os.path.abspath(name)

def _constract_output_file_name(base_input_file_dir, file_name):
    # One subfolder depth
    sub_folder_path = base_input_file_dir.split("/")[-1]

    if sub_folder_path != INPUT_PATH:
        return _full_name(os.path.join(OUTPUT_PATH, sub_folder_path, os.path.basename(os.path.normpath(file_name))))
    else:
        return _full_name(os.path.join(OUTPUT_PATH, os.path.basename(os.path.normpath(file_name))))

def _constract_compare_file_name(base_input_file_dir, file_name):
    # One subfolder depth
    sub_folder_path = base_input_file_dir.split("/")[-1]

    if sub_folder_path != INPUT_PATH:
        return _full_name(os.path.join(EXPECTED_PATH, sub_folder_path, os.path.basename(os.path.splitext(file_name)[0]) + "_Expected_Output.txt"))
    else:
        return _full_name(os.path.join(EXPECTED_PATH, os.path.basename(os.path.splitext(file_name)[0]) + "_Expected_Output.txt"))

print("Start\n\n\n")
for root,d_names,f_names in os.walk(INPUT_PATH):
    for f in f_names:
        if f.endswith(".txt"):
            input_file = os.path.join(root, f)

            full_input_file_name = _full_name(input_file)
            full_output_file_name = _constract_output_file_name(root, input_file)
            full_commpare_file_name = _constract_compare_file_name(root, input_file)

            test_name = 'test_%s' % os.path.splitext(input_file)[0]
            # print("RUNNING TEST({}):\n".format(test_name))
            # continue
            test = test_generator(full_input_file_name, full_output_file_name, full_commpare_file_name)
            test(None)
