#!/usr/bin/python
import argparse
import subprocess
import sys
import logging

# check if 'argcomplete' if it is present on the system
try:
	import argcomplete

	del argcomplete
	_ARG_COMPLETE_SUPPORTED = True
except ImportError:
	_ARG_COMPLETE_SUPPORTED = False

Version = '0.1.0'


class DotLink(object):
	def __init__(self):
		pass

	def install(self, args):
		logging.debug('Installing dotfile packages %s', args.packages)
		pass

	def upload(self, args):
		logging.debug('Deploying dotfile packages %s', args.packages)
		pass


class Package(object):
	pass


def sh(*action, **kwargs):
	"""Run a shell command with the given arguments."""
	return subprocess.check_call(
		" ".join(action),
		stdout=sys.stdout,
		stderr=sys.stderr,
		stdin=sys.stdin,
		shell=True,
		**kwargs
	)


def _setup_parser():
	parser = argparse.ArgumentParser()

	# common options
	parser.add_argument("--debug", action="store_true")

	subparsers = parser.add_subparsers()
	
	# install
	install = subparsers.add_parser("install", help="xxxx")
	install.set_defaults(func="install")

	args = install.add_argument('-c', '--copy', action='store_true')
	args.help = 'copy files rather than link'

	args = install.add_argument('-s', '--source', metavar='path')
	args.help = 'path to root of the source dotfile repo'

	args = install.add_argument('packages', nargs='+')
	args.help = 'one or more packages'

	# upload
	upload = subparsers.add_parser("upload", help="xxxx")
	upload.set_defaults(func="upload")

	if _ARG_COMPLETE_SUPPORTED:
		from argcomplete import autocomplete
		autocomplete(parser)

	return parser


def _setup_logger(debug):
	root = logging.getLogger()

	wr = logging.StreamHandler(sys.stdout)

	if not debug:
		fm = logging.Formatter('%(message)s')
		root.setLevel(logging.INFO)
		wr.setLevel(logging.INFO)
	else:
		fm = logging.Formatter('%(levelname)-8s %(message)s')
		root.setLevel(logging.DEBUG)
		wr.setLevel(logging.DEBUG)

	wr.setFormatter(fm)
	root.addHandler(wr)


def main():
	try:
		# create parser for global arguments
		parser = _setup_parser()
		# parse commandline arguments
		args = parser.parse_args()

		debug = args.debug
		_setup_logger(debug)

		if 'func' not in args:
			parser.print_help()
			return

		instance = DotLink()
		getattr(instance, args.func)(args)

	except KeyboardInterrupt:
		sys.exit(1)
	except argparse.ArgumentTypeError as error:
		sys.exit(2)


if __name__ == "__main__":
	main()
