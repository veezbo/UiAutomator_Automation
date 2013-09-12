import argparse, sys, subprocess, os, shutil
from argparse import RawTextHelpFormatter


#Read in Arguments
parser = argparse.ArgumentParser(description="Description: \n\tBuild and run one or multiple UiAutomator projects at once", epilog="********Example Usages*********\n\npython UiAutomator.py -p /home/vibhor/workspace/Create_Contacts/ -c contacts.create_contacts\n\npython UiAutomator.py -p /home/vibhor/workspace/Create_Contacts/ /home/vibhor/workspace/Contacts_Verification/ -c contacts.create_contacts contacts_verification", formatter_class=RawTextHelpFormatter)
parser._optionals.title = "Flag Arguments"
#parser.add_argument("-n", help="REQUIRED: project names", metavar="project_names", required=True, nargs="+")
parser.add_argument("-p", help="REQUIRED: full path to projects", metavar="project_paths", required=True, nargs="+")
parser.add_argument("-c", help="REQUIRED: package+class names with the tests", metavar="package_names", required=True, nargs="+")


#Print help message if no arguments given
if len(sys.argv) == 1:
	print ""
	parser.print_help()
	print ""
	sys.exit(1)


#Parse Arguments
args = parser.parse_args()


# Ensure that we have been given equal numbers of parameters
if len(args.p) != len(args.c):
	print "ERROR: Enter the same number of project names, project paths, and package names"
	print ""
	parser.print_help()
	print ""
	sys.exit(1)


#Get Name from Project method
def getName(p):
	return p.split('/')[-2]

#Get the names of the projects
n = map(getName, args.p)


#Call the helper script as needed
num_tests=len(n)
ran_tests = 0
for i in range(0, num_tests):
	ran_tests += (subprocess.call(["bash", "uiautomator.sh", "-n "+n[i], "-p "+args.p[i], "-c "+args.c[i]]) ^ 1)


#Finish
print "\nFINISHED ALL UIAUTOMATOR TESTS AND RUNS: " + str(ran_tests) + "/" + str(num_tests) + " ran\n"
sys.exit(0)