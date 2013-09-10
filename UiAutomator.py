import argparse, sys, subprocess


parser = argparse.ArgumentParser(description="Description: Build and run one or multiple UiAutomator projects at once", epilog="Example Usage: python UiAutomator.py -n Create_Contacts -p /home/vibhor/workspace/Create_Contacts -c contacts.create_contacts")
parser.add_argument("-n", help="project names", metavar="project names", required=True, nargs="+")
parser.add_argument("-p", help="full path to projects", metavar="project paths", required=True, nargs="+")
parser.add_argument("-c", help="names of packages where tests are bundled", metavar="package names", required=True, nargs="+")

if len(sys.argv) == 1:
	parser.print_help()
	sys.exit(1)

args = parser.parse_args()

if len(args.n) != len(args.p) or len(args.n) != len(args.c):
	print "ERROR: Enter the same number of project names, project paths, and package names"
	sys.exit(1)

num_tests=len(args.n)
ran_tests = 0
for i in range(0, num_tests):
	ran_tests += (subprocess.call(["bash", "uiautomator.sh", "-n "+args.n[i], "-p "+args.p[i], "-c "+args.c[i]]) ^ 1)

print "\nFINISHED ALL UIAUTOMATOR TESTS AND RUNS: " + str(ran_tests) + "/" + str(num_tests) + " ran\n"
sys.exit(0)