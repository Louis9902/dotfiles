import logging
import subprocess
import sys
import gi
import socket

gi.require_version('Notify', '0.7')

from gi.repository import Notify
from gi.repository import GLib

hostname = socket.gethostname()

exclude_list = [
	'/home/*/Downloads',
	'/home/*/go',
	'/home/*/sdk',
	'/home/*/.var',
	'/home/*/.cache',
	'/home/*/.konan',
	'/home/*/.gradle',
	'/home/*/.java',
	'/home/*/.mozilla',
	'/home/*/.m2',
	'/home/*/.cargo',
	'/home/*/.platformio',
	'/home/*/.config/pulse',
	'/home/*/.config/JetBrains',
	'/home/*/.local/bin',
	'/home/*/.local/share/Trash',
	'/home/*/.local/share/JetBrains/Toolbox',
	'/home/*/.local/share/Steam',
	'/home/*/.local/share/containers',
	'/home/*/.local/share/gvfs-metadata',
	'/media/storage/software',
	'/media/storage/.Trash-*',
]


def sh(env, *command, **kwargs):
	"""Run a shell command with the given arguments."""
	logging.debug('shell: %s', ' '.join(command))
	return subprocess.check_call(' '.join(command), env=env, shell=True, **kwargs)


def backup_create(excludes, paths):
	options = "--show-rc --list --stats --filter AME --compression zstd,10 --exclude-caches"
	exclude = ' '.join(["-e '{0}'".format(name) for name in excludes])
	folders = ' '.join(["'{0}'".format(name) for name in paths])
	command = f"borg create {options} {exclude} ::'{hostname}-{{now}}' {folders}"
	print(command)
	pass


def backup_prune():
	options = " --show-rc --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --list"
	command = f"borg prune {options} --prefix {hostname}-"
	print(command)


loop = GLib.MainLoop()


def main():
	backup_create(exclude_list, ['/home/louis', '/media/storage'])
	backup_prune()
	return 0

	if not Notify.init('Borg Backup Script'):
		print("ERROR: Could not init Notify.")
		sys.exit(1)

	notification = Notify.Notification.new(
		"Notification Title",
		"Message...")

	notification.set_urgency(Notify.Urgency.NORMAL)

	def callback1(context, action, user_data=None):
		print("Callback called:" + action)
		context.close()

	notification.add_action("test-action-1", "Test Action 1", callback1)

	notification.set_timeout(10 * 1000)

	if not notification.show():
		print("ERROR: Could not show notification.")
		sys.exit(2)

	def on_close(context):
		loop.quit()

	notification.connect("closed", on_close)

	loop.run()


if __name__ == '__main__':
	main()
