#!/bin/bash

ignore_install_tools=('install.sh common.sh get_intall_pkg_cmd.sh')

for prefix in ${ignore_install_tools[@]}; do
	ignore_install_tool_str=$ignore_install_tool_str" -I "$prefix
done

install_tools=($(ls $ignore_install_tool_str))
install_status=install_tools
cnt=0
for tool in ${install_tools[@]}; do
	./$tool 'install'

	if [ $? -ne 0 ]; then
		install_status[$cnt]='failed'
	else
		install_status[$cnt]='success'
	fi

	cnt=$cnt+1
done

./common.sh display_tittle 'Installation Status'

for cnt in ${!install_status[@]}; do

	if [ ${install_status[$cnt]} == 'failed' ]; then
		printf "%2s." "*"
	else
		printf "%2d." "$(($cnt+1))"
	fi

	printf "%-20s\t" "${install_tools[$cnt]}"

	if [ ${install_status[$cnt]} == 'failed' ]; then
		echo -e -n "\033[31m"
	else
		echo -e -n "\033[33m"
	fi

	printf "[%-s]\n" "${install_status[$cnt]}"

	echo -e -n "\033[0m"
done

exit 0
