#! /usr/bin/bash
#
# Author: Bert Van Vreckem <bert.vanvreckem@gmail.com>
#
# Install role dependencies using ansible-galaxy (or manually if needed)

# Variables
ansible_dir=ansible
role_dir="${ansible_dir}/roles/"
deps="${ansible_dir}/dependencies.yml"

# Install roles with ansible-galaxy (preferred method)
galaxy_install() {
  ansible-galaxy install \
    --ignore-errors \
    --role-file=${deps} \
    --roles-path=${role_dir}
}

# Install roles from Github (if ansible-galaxy is not available)
# WARNING: this will only work in quite specific cases
#  - the roles should be written by me and be available on my github
#  - the latest version on the master branch should be compatible with the
#    one specified in dependencies.yml
manual_install() {
  local base_url=https://github.com/bertvv/ansible-role-
  local roles=$(grep src ${deps} | sed 's/.*\.//')


  for role in $roles; do
    git clone --config core.autocrlf=false "${base_url}${role}.git" "${role_dir}/bertvv.${role}"
  done
}

# script proper

if [ -n "$(which ansible-galaxy 2> /dev/null)" ]; then
  galaxy_install
else
  manual_install
fi

