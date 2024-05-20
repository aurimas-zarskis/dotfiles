# Paths
DOTFILES_LOG="$HOME/.dotfiles.log"
DOTFILES_DIR="$HOME/.dotfiles"
VAULT_SECRET="$HOME/.ansible-vault/vault.secret"

function _task {
  # if _task is called while a task was set, complete the previous
  if [[ $TASK != "" ]]; then
    printf "${OVERWRITE}${LGREEN} [✓]  ${LGREEN}${TASK}\n"
  fi
  # set new task title and print
  TASK=$1
  printf "${LBLACK} [ ]  ${TASK} \n${LRED}"
}

# _cmd performs commands with error checking
function _cmd {
  #create log if it doesn't exist
  if ! [[ -f $DOTFILES_LOG ]]; then
    touch $DOTFILES_LOG
  fi
  # empty conduro.log
  > $DOTFILES_LOG
  # hide stdout, on error we print and exit
  if eval "$1" 1> /dev/null 2> $DOTFILES_LOG; then
    return 0 # success
  fi
  # read error from log and add spacing
  printf "${OVERWRITE}${LRED} [X]  ${TASK}${LRED}\n"
  while read line; do
    printf "      ${line}\n"
  done < $DOTFILES_LOG
  printf "\n"
  # remove log file
  rm $DOTFILES_LOG
  # exit installation
  exit 1
}

function _clear_task {
  TASK=""
}

function _task_done {
  printf "${OVERWRITE}${LGREEN} [✓]  ${LGREEN}${TASK}\n"
  _clear_task
}

function update_ansible_galaxy() {
  _task "Updating Ansible Galaxy"; _task_done
  _cmd "ansible-galaxy install -r $DOTFILES_DIR/requirements/common.yml"
}

# Install homebrew
_task "Installing homebrew"; _task_done
if test ! $(which brew); then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install Ansible
_task "Install Ansible"; _task_done
if test ! $(which ansible); then
  brew install ansible
fi

# Update Ansible galaxy
update_ansible_galaxy

# Run playbook
_task "Running Ansible playbook"; _task_done
if [[ -f $VAULT_SECRET ]]; then
  ansible-playbook --ask-become-pass --vault-password-file $VAULT_SECRET "$DOTFILES_DIR/main.yml" "$@"
else
  touch $VAULT_SECRETC
  echo "Vault secret $VAULT_SECRET is missing. Please add it to continue"
  exit 1
fi
