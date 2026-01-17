# dgx-spark-minikube

Ansible automation project for deploying Kubernetes (Minikube) on NVIDIA DGX Spark.

## Overview

This project automates the setup of a Kubernetes-based development environment on [NVIDIA DGX Spark](https://build.nvidia.com/spark) workstations powered by the GB10 Grace Blackwell Superchip (ARM64). It configures:

- **Kubernetes** via Minikube for container orchestration
- **Syncthing** for real-time file synchronization across nodes
- **Python 3.12 & 3.14** development environments
- **System utilities** including AWS S3 tools

## Architecture

```
Control Machine (WSL/Linux)
    │ (Ansible via SSH)
    ▼
┌───────────────────────────────┐     ┌───────────────────────────────┐
│  DGX Spark 1 (192.168.30.28)  │     │  DGX Spark 2 (192.168.30.29)  │
├───────────────────────────────┤     ├───────────────────────────────┤
│ • Docker + Minikube           │     │ • Docker + Minikube           │
│ • kubectl                     │◄───►│ • kubectl                     │
│ • Python 3.12 + 3.14          │     │ • Python 3.12 + 3.14          │
│ • Syncthing                   │     │ • Syncthing                   │
│ • AWS S3 tools                │     │ • AWS S3 tools                │
└───────────────────────────────┘     └───────────────────────────────┘
              ▲                                    ▲
              └────── Syncthing File Sync ─────────┘
```

## Prerequisites

- NVIDIA DGX Spark workstation(s) with Docker pre-installed
- Ansible installed on the control machine
- SSH access to the DGX Spark systems
- SSH key at `~/.ssh/spark_ansible_rsa`
- Sudo access on target systems

## Quick Start

1. **Generate SSH key** (if not already done):
   ```bash
   ssh-keygen -f ~/.ssh/spark_ansible_rsa
   ssh-copy-id -i ~/.ssh/spark_ansible_rsa user@<dgx-spark-1-ip>
   ssh-copy-id -i ~/.ssh/spark_ansible_rsa user@<dgx-spark-2-ip>
   ```

2. **Update inventory**:
   Edit `hosts-spark.yml` to match your DGX Spark IP addresses.

3. **Run the setup**:
   ```bash
   ./run.sh
   ```

## Selective Deployment

Use Ansible tags to deploy specific components:

```bash
./run.sh -t system        # System utilities (mc, btop, s3cmd)
./run.sh -t kubernetes    # kubectl + Minikube
./run.sh -t syncthing     # File synchronization
./run.sh -t python        # Python 3.12 + 3.14
```

## Components Installed

All binaries are ARM64-native for the DGX Spark's Grace Blackwell architecture.

| Component | Version | Purpose |
|-----------|---------|---------|
| kubectl | v1.35.0 | Kubernetes cluster management |
| Minikube | v1.37.0 | Single-node Kubernetes clusters |
| Python | 3.12, 3.14 | Development environments |
| Syncthing | latest | File synchronization |
| s3cmd | latest | AWS S3 CLI |

## Project Structure

```
dgx-spark-minikube/
├── setup-spark.yaml     # Main Ansible playbook
├── hosts-spark.yml      # Inventory (target servers)
├── run.sh               # Execution wrapper script
├── LICENSE              # MIT License
└── README.md
```

## Systemd Services

The playbook configures automatic service management:

- **Minikube**: Starts automatically on boot via `minikube@<user>.service`
- **Syncthing**: Runs continuously as a user service `syncthing@<user>.service`
