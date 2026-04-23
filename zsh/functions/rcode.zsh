# recode
# runs the visual stuido code from the ssh server
function rcode() {
	if [ $# -eq 0 ]; then
		echo "Example usage:"
		echo "  rcode [SSH_HOST] [PROJECT_DIR]"
		return 1
	fi

	if [ $# -ne 2 ]; then
		print -P "%F{red}Error%f: rcode requires exactly two arguments"
		return 1
	fi

	host=$1
	dir=$2
	echo "code --folder-uri vscode-remote://ssh-remote+${host}${dir}"

	if [[ $host =~ ^[^@]+@.* ]]; then
		code --folder-uri vscode-remote://ssh-remote+${host}${dir}
		return 0
	else
		if ! grep -q "^Host $host" ~/.ssh/config; then
			print -P "%F{red}Error%f: Invalid SSH hostname: $host"
			return 1
		fi
	fi

	code --folder-uri vscode-remote://ssh-remote+${host}${dir}
	return 0
}
