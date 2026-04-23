# dotenv - load environment variables from a file into the current shell session
# usage: dotenv [file]
# args:  file path (optional, defaults to .env)

function dotenv() {
	local env_file="${1:-.env}" # use first argument as file path, default to .env

	if [[ -f "$env_file" ]]; then
		export $(rg -v '^#' "$env_file" | xargs)
		echo "Loaded environment variables from $env_file success"
	else
		echo "File $env_file not found"
		return 1
	fi
}
