#!/usr/bin/python3

import os
import unittest
import filecmp

INPUT_PATH = "FOLDER_4_INPUT"

OUTPUT_PATH = "FOLDER_5_OUTPUT"
EXPECTED_PATH = "FOLDER_6_EXPECTED_OUTPUT"

def ensure_path(path):
    directory = "/".join(path.split("/")[0:-1])
    print(directory)
    if not os.path.exists(directory):
        os.makedirs(directory)

class TestSequense(unittest.TestCase):
    pass

def test_generator(input_file, output_file, compare_file):
    def test(self):
        print("input = {} \noutput = {} \ncompare = {}\n\n\n\n".format(input_file, output_file, compare_file))

        ensure_path(input_file)
        ensure_path(output_file)

        os.system("java -jar COMPILER {input} {output}".format(input=input_file, output=output_file))

        ensure_path(compare_file)
        if os.path.exists(compare_file):
            filecmp.cmp(output_file, compare_file)
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

if __name__ == '__main__':
    # run make
    for root,d_names,f_names in os.walk(INPUT_PATH):
        for f in f_names:
            if f.endswith(".txt"):
                input_file = os.path.join(root, f)

                full_input_file_name = _full_name(input_file)
                full_output_file_name = _constract_output_file_name(root, input_file)
                full_commpare_file_name = _constract_compare_file_name(root, input_file)

                test_name = 'test_%s' % os.path.splitext(input_file)[0]
                print("RUNNING TEST({}):".format(test_name))
                # continue
                test = test_generator(full_input_file_name, full_output_file_name, full_commpare_file_name)
                setattr(TestSequense, test_name, test)

    unittest.main()
