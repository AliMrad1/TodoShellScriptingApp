#!/bin/bash

TACHES=$HOME/.todo_list

todo(){
       #nb of lines(tasks) in our todo list
	nb_lines=$(wc -l < $TACHES)
        #to switch between list tasks / add a task / remove a task
        case $1 in
           list)
              # nl command used for numbering line
              # -w option to manipulate the spaces that precedes the number in which we get rid of the space entirely
              # -w s option to add a string after the numbers in our case we added " - "
              nl -w 1 -s " - " $TACHES
              ;;
           add)
              #if statement used to prevent user to enter a postion less than 1 which is can't be added to the list
              #elif condition to prevent user from adding an empty line to list when not inserting sny new task.
              if [[ $2 -lt 1 ]]
              then
                 echo "Position chosen for the new task should be a number greater than zero"
              elif [[ -z "$3" ]]
              then
                 echo " NO new task is added"  
              else  
	         # $2 dedicated position in the list for the new task 
	         
      	         # $3 the new task to add
      	         
      	         # $(($2-1)) position of the task preceding the position assigned for the new one
      	         
      	         # touch command used to create a temporary file
      	         # it can be not used since redirecting will create automatically the temporary file
	         touch todo_temp.txt
	         # next command line functionality : head command is used to take the first n line from the todo list preceding the line
	         # assigned by the user for the new task and redirect them to temporary file
	         # -n option used to specify the number of line 
	         head -n $(($2-1)) $TACHES > todo_temp.txt
	         # next command line functionality : redirecting the new task entered by the user to temporary file
	         echo $3 >> todo_temp.txt
	         # next command line functionality : to add the remaining tasks by redirecting them to temporary file 
	         # starting from the task that its position will be taken by the added one
	         tail +$2 $TACHES >> todo_temp.txt
	         # next command line functionality : finally redirecting the temporary file containging all new infos to the main file
	         cat todo_temp.txt > $TACHES
	         # next command line functionality : remove temprary file using rm command
	         rm todo_temp.txt 
	         # if statement to properly inform the user about tasks positions managing when the position entered for the new task is
	         # greater from the number of lines already used in the todo file in which it'll take last available position not the one
	         # set by the user 
	         if [[ $(($nb_lines+1)) -lt $2 ]]
	         then
	            echo " the task '$3' is added in position $(($nb_lines+1))"
	         else   
	            echo " the task '$3' is added in position "$2" "
	         fi
	             
	      fi
	      ;;
	   'done')
	      # if statement to prevent executing the script if the position of the task entered by user overflowing list positions. 
	      if [[ $2 -lt 1 ]]
	      then
	         echo "the minimum numbering of task in list is 1"
	    
	      elif [[ $nb_lines -gt $(($2-1)) ]] 
	      then
	      touch todo_temp.txt
	      # next command line functionality :take the tasks preceding the one specified to be removed by the user as done
	      # redirect them to temp file
	      # -n option to specify these X first number of line and the arithmetic operation to calculate X depending on user choice
              head -n $(($2-1)) $TACHES > todo_temp.txt
              # next command line functionality : to add the remaining tasks by redirecting them to temporary file 
	      # starting from the task cames right after the one selected to be removed as done
              tail +$(($2+1)) $TACHES >> todo_temp.txt
              # next command line functionality :to extract the task from the list and show it to user upon removing 
              # using head command to extract line till the targeted task and piping them to tail command to extract
              # the last one (targeted task) 
              echo " the task $2 ($(head -n $2 $TACHES | tail +$2)) is done. " 
              cat todo_temp.txt > $TACHES
	       rm todo_temp.txt
	       else
	          echo " The maximum number of tasks in your list is $nb_lines"
	       fi   
	      ;;
	      # here we insert a help option useful for users
	   'help')
	      echo "please make sure to proceed by one of these arguments:"
	      echo "* list : to list your todo list"
	      echo "* add [position] [task to add]: to add new todo task in a specific position "
	      echo " if you want to add a task as a string containing space please insert it in a double quotation"
	      echo "* done [position]: to remove an accomplished task by its position"
	      ;;
	    # we used the default case to inform the user about the help option in case of any misconception     
	   *) 
	      echo "inappropriate input..please enter todo help for information "
	      ;;
	esac         
                
 }
 
