# ssh setup
#first ssh into the box one time
ssh pcampbe@kubenode3

#then run ssh-keygen to set up the .ssh folder and default key
ssh-keygen -t rsa

#now exit and cat your public key to each of the servers authorized_keys files
cat ~/.ssh/id_rsa.pub | ssh pcampbe@kubenode3 'cat >> ~/.ssh/authorized_keys'

ssh pcampbe@kubenode3

#install tmux if you have not done so yet
sudo apt-get install tmux 

#Type the commands for the install on several servers simultaneously using the
#synchronize-panes feature of tmux. Synchronize-panes can be enabled by
# ctrl+b then (shift) : then type 
set synchronize-panes on 

#splitting panes and dispersing them evenly after they are split

# ctrl+b then shift " to split and ctrl+b then (shift) " to split again

# ctrl+b alt+2 (even verts) or ctrl+b alt+1 (even horiz)

# ctrl+b o to jump to cycle to the next terminal

# ctrl+b ; to jump back to previous

#To disable synchronization again use ctrl+b then (shift) : then type
set synchronize-panes off.
