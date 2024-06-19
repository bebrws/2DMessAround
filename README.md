certbot

ON AWS RAN:

sudo certbot certonly -d zkpf.io

[ec2-user@ip-172-31-21-146 bin]$ sudo cp -r /etc/letsencrypt/archive/zkpf.io ~/
[ec2-user@ip-172-31-21-146 bin]$ sudo chown -R  ec2-user:ec2-user ~/zkpf.io

Files in:
$HOME/zkpf.io
FOR NOW - need ot recreate on 2024-09-17
