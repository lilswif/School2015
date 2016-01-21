#! /usr/bin/env bats
#
# Author:   Bert Van Vreckem <bert.vanvreckem@gmail.com>
#
# Test a Samba server

#smbclient "//SambaBaby/verzekeringen" --user=maaiked%maaiked --command='ls'


sut_ip=172.16.0.11         # IP of the system under test
sut_wins_name=FILES   # NetBIOS name
workgroup=LINUXLAB         # Workgroup
admin_user=fred            #er with admin privileges
admin_password=fred

samba_share_root=/srv/shares # Root directory of shares
# The name of a directory and file that will be created to test for
# write access (= random string)
test_dir=peghawJaup
test_file=Nocideicye

# {{{Helper functions

teardown() {
  # Remove all test directories and files
  find "${samba_share_root}" -maxdepth 2 -type d -name "${test_dir}" \
    -exec rm -rf {} \;
  find "${samba_share_root}" -maxdepth 2 -type f -name "${test_file}" \
    -exec rm {} \;
  rm -f "${test_file}"
}

# Checks if a user has shell access to the system
# Usage: assert_can_login USER PASSWD
assert_can_login() {
  echo $2 | su -c 'ls ${HOME}' - $1
}

# Checks that a user has NO shell access to the system
# Usage: assert_cannot_login USER
assert_cannot_login() {
  run sudo su -c 'ls' - $1
  [ "0" -ne "${status}" ]
}

# Check that a user has read acces to a share
# Usage: read_access SHARE USER PASSWORD
assert_read_access() {
  local share="${1}"
  local user="${2}"
  local password="${3}"

  run smbclient "//${sut_wins_name}/${share}" \
    --user=${user}%${password} \
    --command='ls'
  [ "${status}" -eq "0" ]
}

# Check that a user has NO read access to a share
# Usage: no_read_access SHARE USER PASSWORD
assert_no_read_access() {
  local share="${1}"
  local user="${2}"
  local password="${3}"

  run smbclient "//${sut_wins_name}/${share}" \
    --user=${user}%${password} \
    --command='ls'
  [ "${status}" -eq "1" ]
}

# Check that a user has write access to a share
# Usage: write_access SHARE USER PASSWORD
assert_write_access() {
  local share="${1}"
  local user="${2}"
  local password="${3}"

  run smbclient "//${sut_wins_name}/${share}" \
    --user=${user}%${password} \
    --command="mkdir ${test_dir};rmdir ${test_dir}"
  # Output should NOT contain any error message. Checking on exit status is
  # not reliable, it can be 0 when the command failed...
  [ -z "$(echo ${output} | grep NT_STATUS_)" ]
}

# Check that a user has NO write access to a share
# Usage: no_write_access SHARE USER PASSWORD
assert_no_write_access() {
  local share="${1}"
  local user="${2}"
  local password="${3}"

  run smbclient "//${sut_wins_name}/${share}" \
    --user=${user}%${password} \
    --command="mkdir ${test_dir};rmdir ${test_dir}"
  # Output should contain an error message (beginning with NT_STATUS, usually
  # NT_STATUS_MEDIA_WRITE_PROTECTED
  [ -n "$(echo ${output} | grep NT_STATUS_)" ]
}

# Check that users from the same group can write to each other’s files
# Usage: assert_group_write_file SHARE USER1 PASSWD1 USER2 PASSWD2
assert_group_write_file() {
  local share="${1}"
  local user1="${2}"
  local passwd1="${3}"
  local user2="${4}"
  local passwd2="${5}"

  echo "Hello world!" > ${test_file}

  smbclient "//${sut_wins_name}/${share}" --user=${user1}%${passwd1} \
    --command="put ${test_file}"
  # In order to overwrite the file, write access is needed. This will fail
  # if user2 doesn’t have write access.
  smbclient "//${sut_wins_name}/${share}" --user=${user2}%${passwd2} \
    --command="put ${test_file}"
}

# Check that users from the same group can write to each other’s directories
# Usage: assert_group_write_dir SHARE USER1 PASSWD1 USER2 PASSWD2
assert_group_write_dir() {
  local share="${1}"
  local user1="${2}"
  local passwd1="${3}"
  local user2="${4}"
  local passwd2="${5}"

  smbclient "//${sut_wins_name}/${share}" --user=${user1}%${passwd1} \
    --command="mkdir ${test_dir}; mkdir ${test_dir}/tst"
  run smbclient "//${sut_wins_name}/${share}" --user=${user2}%${passwd2} \
    --command="rmdir ${test_dir}/tst"
  [ -z $(echo "${output}" | grep NT_STATUS_ACCESS_DENIED) ]
}

#}}}

# Preliminaries

@test 'The ’nmblookup’ command should be installed' {
  which nmblookup
}

@test 'The ’smbclient’ command should be installed' {
  which smbclient
}

@test 'The Samba service should be running' {
  systemctl status smb.service
}

@test 'The Samba service should be enabled at boot' {
  systemctl is-enabled smb.service
}

@test 'The WinBind service should be running' {
  systemctl status nmb.service
}

@test 'The WinBind service should be enabled at boot' {
  systemctl is-enabled nmb.service
}

@test 'The SELinux status should be ‘enforcing’' {
  [ -n "$(sestatus) | grep 'enforcing'" ]
}

@test 'Samba traffic should pass through the firewall' {
  firewall-cmd --list-all | grep 'services.*samba\b'
}

#
# 'White box' tests
#

# Users

@test 'Check existence of users' {
  id -u franka
  id -u femkevdv
  id -u hansb
  id -u peterj
  id -u kimberlyvh
  id -u taniav
  id -u maaiked
  id -u ${admin_user}
}

@test 'Checks shell access of users' {
  assert_cannot_login franka
  assert_cannot_login femkevdv
  assert_cannot_login hansb
  assert_cannot_login peterj
  assert_cannot_login kimberlyvh
  assert_cannot_login taniav

  assert_can_login maaiked maaiked
  assert_can_login ${admin_user} ${admin_password}
}

#
# Black box, acceptance tests
#

# Samba configuration

@test 'Samba configuration should be syntactically correct' {
  testparm --suppress-prompt /etc/samba/smb.conf
}

@test 'NetBIOS name resolution should work' {
  # Look up the Samba server’s NetBIOS name under the specified workgroup
  # The result should contain the IP followed by NetBIOS name
  nmblookup -U ${sut_ip} --workgroup ${workgroup} ${sut_wins_name} \
    | grep "^${sut_ip} ${sut_wins_name}"
}

# Read / write access to shares

@test 'Read access for share ‘publiek’' {
  #                  Share   User          Password
  assert_read_access publiek franka        franka
  assert_read_access publiek femkevdv      femkevdv
  assert_read_access publiek hansb         hansb
  assert_read_access publiek kimberlyvh    kimberlyvh
  assert_read_access publiek taniav        taniav
  assert_read_access publiek peterj        peterj
  assert_read_access publiek maaiked       maaiked
  assert_read_access publiek ${admin_user} ${admin_password}
}

@test 'Write access for share ‘publiek’' {
  #                   Share   User          Password
  assert_write_access publiek franka        franka
  assert_write_access publiek femkevdv      femkevdv
  assert_write_access publiek hansb         hansb
  assert_write_access publiek kimberlyvh    kimberlyvh
  assert_write_access publiek taniav        taniav
  assert_write_access publiek peterj        peterj
  assert_write_access publiek maaiked       maaiked
  assert_write_access publiek ${admin_user} ${admin_password}
}

@test 'Read access for share ‘verzekeringen’' {
  #                  Share         User          Password
  assert_read_access verzekeringen franka        franka
  assert_read_access verzekeringen femkevdv      femkevdv
  assert_read_access verzekeringen hansb         hansb
  assert_read_access verzekeringen kimberlyvh    kimberlyvh
  assert_read_access verzekeringen taniav        taniav
  assert_read_access verzekeringen peterj        peterj
  assert_read_access verzekeringen maaiked       maaiked
  assert_read_access verzekeringen ${admin_user} ${admin_password}
}

@test 'Write access for share ‘verzekeringen’' {
  #                      Share         User          Password
  assert_write_access    verzekeringen franka        franka
  assert_no_write_access verzekeringen femkevdv      femkevdv
  assert_write_access    verzekeringen hansb         hansb
  assert_write_access    verzekeringen taniav        taniav
  assert_no_write_access verzekeringen peterj        peterj
  assert_write_access    verzekeringen maaiked       maaiked
  assert_write_access    verzekeringen ${admin_user} ${admin_password}
}

@test 'Read access for share ‘financieringen’' {
  #                  Share          User          Password
  assert_read_access financieringen franka        franka
  assert_read_access financieringen femkevdv      femkevdv
  assert_read_access financieringen hansb         hansb
  assert_read_access financieringen taniav        taniav
  assert_read_access financieringen peterj        peterj
  assert_read_access financieringen maaiked       maaiked
  assert_read_access financieringen ${admin_user} ${admin_password}
}

@test 'Write access for share ‘financieringen’' {
  #                      Share          User          Password
  assert_write_access    financieringen franka        franka
  assert_no_write_access financieringen femkevdv      femkevdv
  assert_no_write_access financieringen hansb         hansb
  assert_no_write_access financieringen taniav        taniav
  assert_write_access    financieringen peterj        peterj
  assert_write_access    financieringen maaiked       maaiked
  assert_write_access    financieringen ${admin_user} ${admin_password}
}

@test 'Read access for share ‘staf’' {
  #                  Share User         Password
  assert_read_access staf franka        franka
  assert_read_access staf femkevdv      femkevdv
  assert_read_access staf hansb         hansb
  assert_read_access staf kimberlyvh    kimberlyvh
  assert_read_access staf taniav        taniav
  assert_read_access staf peterj        peterj
  assert_read_access staf maaiked       maaiked
  assert_read_access staf ${admin_user} ${admin_password}
}

@test 'Write access for share ‘staf’' {
  #                      Share User         Password
  assert_write_access    staf franka        franka
  assert_write_access    staf femkevdv      femkevdv
  assert_no_write_access staf hansb         hansb
  assert_no_write_access staf kimberlyvh    kimberlyvh
  assert_no_write_access staf taniav        taniav
  assert_no_write_access staf peterj        peterj
  assert_write_access    staf maaiked       maaiked
  assert_write_access    staf ${admin_user} ${admin_password}
}

@test 'Read access for share ‘directie’' {
  #                     Share    User          Password
  assert_read_access    directie franka        franka
  assert_read_access    directie femkevdv      femkevdv
  assert_no_read_access directie hansb         hansb
  assert_no_read_access directie kimberlyvh    kimberlyvh
  assert_no_read_access directie taniav        taniav
  assert_no_read_access directie peterj        peterj
  assert_read_access    directie maaiked       maaiked
  assert_read_access    directie ${admin_user} ${admin_password}
}

@test 'Write access for share ‘directie’' {
  #                      Share    User          Password
  assert_write_access    directie franka        franka
  assert_write_access    directie femkevdv      femkevdv
  assert_no_write_access directie hansb         hansb
  assert_no_write_access directie kimberlyvh    kimberlyvh
  assert_no_write_access directie taniav        taniav
  assert_no_write_access directie peterj        peterj
  assert_write_access    directie maaiked       maaiked
  assert_write_access    directie ${admin_user} ${admin_password}
}

@test 'Read access for share ‘beheer’' {
  #                     Share  User          Password
  assert_no_read_access beheer franka        franka
  assert_no_read_access beheer femkevdv      femkevdv
  assert_no_read_access beheer hansb         hansb
  assert_no_read_access beheer kimberlyvh    kimberlyvh
  assert_no_read_access beheer taniav        taniav
  assert_no_read_access beheer peterj        peterj
  assert_read_access    beheer maaiked       maaiked
  assert_read_access    beheer ${admin_user} ${admin_password}
}

@test 'Write access for share ‘beheer’' {
  #                      Share  User          Password
  assert_no_write_access beheer franka        franka
  assert_no_write_access beheer femkevdv      femkevdv
  assert_no_write_access beheer hansb         hansb
  assert_no_write_access beheer kimberlyvh    kimberlyvh
  assert_no_write_access beheer taniav        taniav
  assert_no_write_access beheer peterj        peterj
  assert_write_access    beheer maaiked       maaiked
  assert_write_access    beheer ${admin_user} ${admin_password}
}

@test "Check read access on home directories" {
  #                  Share         User          Password
  assert_read_access franka        franka        franka
  assert_read_access femkevdv      femkevdv      femkevdv
  assert_read_access hansb         hansb         hansb
  assert_read_access peterj        peterj        peterj
  assert_read_access kimberlyvh    kimberlyvh    kimberlyvh
  assert_read_access taniav        taniav        taniav
  assert_read_access maaiked       maaiked       maaiked
  assert_read_access ${admin_user} ${admin_user} ${admin_password}
}

@test "Check write access on home directories" {
  #                   Share         User          Password
  assert_write_access franka        franka        franka
  assert_write_access femkevdv      femkevdv      femkevdv
  assert_write_access hansb         hansb         hansb
  assert_write_access peterj        peterj        peterj
  assert_write_access kimberlyvh    kimberlyvh    kimberlyvh
  assert_write_access taniav        taniav        taniav
  assert_write_access maaiked       maaiked       maaiked
  assert_write_access ${admin_user} ${admin_user} ${admin_password}
}

# TODO: add tests for group write access
# Use functions assert_group_write_file and assert_group_write_dir (see above)

@test "check group wr acc on files" {
  #Share User1 Passwd1 user2 passwd2
  assert_group_write_file directie fred  fred  maaiked maaiked
  assert_group_write_file financieringen fred  fred  maaiked maaiked
  assert_group_write_file staf fred  fred  maaiked maaiked
  assert_group_write_file verzekeringen fred  fred  maaiked maaiked
  assert_group_write_file publiek fred  fred  maaiked maaiked
  assert_group_write_file beheer fred  fred  maaiked maaiked
  assert_group_write_file verzekeringen fred  fred  maaiked maaiked
}

@test "check group wirte acces on directies" {
   #                      Share    Usr1 Pwd1 user2   passwd2
  assert_group_write_dir directie fred  fred  maaiked maaiked
  assert_group_write_dir financieringen fred  fred  maaiked maaiked
  assert_group_write_dir staf fred  fred  maaiked maaiked
  assert_group_write_dir verzekeringen fred  fred  maaiked maaiked
  assert_group_write_dir publiek fred  fred  maaiked maaiked
  assert_group_write_dir beheer fred  fred  maaiked maaiked
  assert_group_write_dir verzekeringen fred  fred  maaiked maaiked
}