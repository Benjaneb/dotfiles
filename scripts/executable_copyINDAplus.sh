#!/bin/sh
# This script copies all of the student's solutions on 
# IndaPlus Github to their respective repos on KTH Github
#
# Author: Benjamin Widman (bwidman)

# repo_names is a file with every row consisting of each task number
# paired with the plus assignment name seperated by =
# Like so: 2=rustIntro
#
# student_names is a file with all of the student's KTH ID's on separate lines

repo_names_path=repo_names.txt
student_names_path=student_names.txt
working_dir=student_repos/
indaplus_ssh=git@github.com:IndaPlus23/
instructions_name=RaySorcerers-Instructions
kth_github_ssh=git@gits-15.sys.kth.se:inda-23/
error_file=errors.txt

task_nums=($(awk -F= '{ print $1 }' ${repo_names_path}))
assignments=($(awk -F= '{ print $2 }' ${repo_names_path}))
students=($(cat ${student_names_path}))

mkdir -p ${working_dir}
cd ${working_dir}
git clone -q ${indaplus_ssh}${instructions_name}.git

for i in ${!task_nums[@]}; do
	for student in ${students[@]}; do
		plus_repo_name=${student}-${assignments[$i]}
		git clone -q ${indaplus_ssh}${plus_repo_name}.git
		if [ $? -eq 1 ]; then
			echo "Couldn't find ${plus_repo_name}" >> ../${error_file}
			continue
		fi
		rm -rf ${plus_repo_name}/.git/
		
		kth_repo_name=${student}-task-${task_nums[$i]}
		git clone -q ${kth_github_ssh}${kth_repo_name}.git
		if [ $? -eq 1 ]; then
			echo "Couldn't find ${kth_repo_name}" >> ../${error_file}
			continue
		fi
		
		# Copy over plus solution into KTH repo
		mkdir -p ${kth_repo_name}/plus/
		cp -r ${plus_repo_name}/ ${kth_repo_name}/plus/
		
		# For instruction name (1-9 has leading zero: 01)
		plus_numbering=${task_nums[$i]}
		if [ ${task_nums[$i]} -lt 10 ]; then
			plus_numbering=0${plus_numbering}
		fi
		
		# Copy over instructions
		mkdir -p ${kth_repo_name}/plus/instructions/
		cp -r ${instructions_name}/task-${plus_numbering}-${assignments[$i]}/ ${kth_repo_name}/plus/instructions/
		
		# Push changes to KTH Github
		cd ${kth_repo_name}
		git add .
		git commit -q -m "Add plus assignment"
		git push -q

		cd ..
		rm -rf ${plus_repo_name}
		rm -rf ${kth_repo_name}

		echo "Done with student ${student} task ${assignments[$i]}!"
	done
done


cd ..
rm -rf ${working_dir}
echo Done with all students!
