# Automated Dashboard + Counting Deployment with Ansible

A small end-to-end DevOps portfolio project that provisions two Ubuntu VMs and uses Ansible to deploy:

- **Dashboard VM** — Nginx on `192.168.30.11:9002`
- **Counting VM** — Flask + Gunicorn on `192.168.30.12:9001`
- **Ansible Control Node** — your local Ubuntu workstation

The dashboard uses Nginx as a reverse proxy so browser requests to `/api/*` are forwarded to the counting service.

## Architecture

```text
                         Ubuntu Workstation
                    Ansible Control Node
                              |
                 SSH + Ansible Playbooks
                              |
              +---------------+---------------+
              |                               |
              v                               v
       dashboard01                       counting01
      192.168.30.11                     192.168.30.12
       Nginx :9002                    Flask/Gunicorn :9001
              |                               ^
              |------ /api/* reverse proxy ---|
              |
              v
          Web Browser
```

## Skills demonstrated

- Ansible inventory
- Ansible roles
- Variables
- Jinja2 templates
- Handlers
- Idempotent configuration management
- Linux administration
- systemd
- Nginx
- Flask
- Gunicorn
- Reverse proxy
- Multi-server application deployment
- Basic health checks and testing

## Prerequisites

On your Ubuntu control machine:

```bash
sudo apt update
sudo apt install -y ansible vagrant virtualbox
```

Check:

```bash
ansible --version
vagrant --version
VBoxManage --version
```

## 1. Start the VMs

From the project root:

```bash
vagrant up
```

Verify:

```bash
vagrant status
```

Expected:

```text
dashboard01   running
counting01    running
```

## 2. Test Ansible connectivity

```bash
ansible all -m ping
```

Expected for both hosts:

```text
SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

If SSH key paths are different on your system, inspect them with:

```bash
vagrant ssh-config dashboard01
vagrant ssh-config counting01
```

Then update `inventory/hosts.ini`.

## 3. Run the full deployment

```bash
ansible-playbook playbooks/site.yml
```

You should see plays for:

1. Common packages
2. Counting API
3. Dashboard

Run the same command a second time to check idempotency. Most tasks should report `ok` instead of `changed`.

## 4. Test the counting API

```bash
curl http://192.168.30.12:9001/health
```

Expected:

```json
{"status":"ok"}
```

Increment the counter:

```bash
curl http://192.168.30.12:9001/count
```

Example:

```json
{"count":1,"service":"counting"}
```

## 5. Open the dashboard

Open:

```text
http://192.168.30.11:9002
```

Click **Increment Count**.

Traffic flow:

```text
Browser
  |
  v
192.168.30.11:9002
Nginx
  |
  | /api/count
  v
192.168.30.12:9001/count
Counting API
```

## 6. Test everything automatically

```bash
chmod +x scripts/test.sh
./scripts/test.sh
```

## Useful troubleshooting

### Check counting service

```bash
vagrant ssh counting01
sudo systemctl status counting
sudo journalctl -u counting -n 50 --no-pager
curl http://127.0.0.1:9001/health
```

### Check dashboard

```bash
vagrant ssh dashboard01
sudo systemctl status nginx
sudo nginx -t
curl http://127.0.0.1:9002
```

### Test connectivity from dashboard to counting

```bash
vagrant ssh dashboard01
curl http://192.168.30.12:9001/health
```

### Re-run only one role

Counting:

```bash
ansible-playbook playbooks/site.yml --limit counting
```

Dashboard:

```bash
ansible-playbook playbooks/site.yml --limit dashboard
```

## Destroy the lab

```bash
vagrant destroy -f
```

## Portfolio talking points

You can describe this project like this:

> Automated a two-tier application deployment using Ansible roles, Jinja2 templates, handlers, systemd, Nginx, Flask, and Gunicorn. The dashboard server reverse-proxies API requests to a separate counting backend, while Ansible manages package installation, configuration, deployment, service lifecycle, and health checks across both hosts.

## Suggested next upgrades

- Add Ansible Vault for secrets.
- Add GitHub Actions with `ansible-lint`.
- Add Molecule testing.
- Move the same architecture to AWS EC2.
- Add Prometheus + Grafana monitoring.
- Add TLS with Nginx.
- Add a database so the counter persists after service restarts.
