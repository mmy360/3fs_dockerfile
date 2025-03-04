# 3FS Docker 构建环境

这是一个用于编译Fire-Flyer File System（3FS）的Docker容器环境，基于Ubuntu 22.04 LTS并预装了所有必要的依赖项。

## 特性

- 预配置构建工具链（Clang 14, CMake, GCC 12等）
- 包含所有系统级依赖项（libuv, boost, FUSE3等）
- 集成FoundationDB 7.1+客户端库
- 预装Rust工具链（最新稳定版）
- 支持RDMA网络配置（可选）

## 快速开始

### 前置条件

- Docker Engine 20.10+
- 至少10GB可用磁盘空间
- 推荐分配4核CPU/8GB内存

### 构建镜像

```bash
git clone https://github.com/your-username/3fs-docker.git
cd 3fs-docker
docker build -t 3fs-builder:latest .
