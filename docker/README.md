## 🐳 Docker

### 🚧 Pre-Release Developer Notice

**Important Context**  
This release has been marked as experimental because:  
⚠️ **I have been unable to personally validate the build** due to:

- Unstable power infrastructure
- Unreliable internet connectivity

**Your Contribution is needed !!**

### 🛠️ Build Instructions

#### 1. Clone Repository

```bash
git clone https://github.com/odell0111/turnstile_solver.git
cd turnstile_solver
```

#### 2. Build Image

```bash
# Clean build with fresh dependencies
docker compose build --no-cache --pull
```

#### 3. Start the Container

**Command** (with environment variables):

```bash
docker compose up -d \
  -e TZ="America/New_York" \
  -e START_SERVER="true"
```

**Key Parameters**:

- `TZ`: Set your [IANA timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)  
  *(Example: Europe/London, Asia/Dubai)*
- `START_SERVER`:
    - `true` = Auto-start with default config
    - `false` = Manual start required

### 🔌 Remote Access Configuration

**Current Protocol (RDP)**:

1. **Client Software**:
    - Windows: Built-in Remote Desktop Connection
    - Linux: `Remmina` or `FreeRDP`
    - macOS: Microsoft Remote Desktop

2. **Connection Details**:
    - Address: `localhost:3389`
    - Credentials:
        - Username: `root`
        - Password: `root` (❗Change after first login)

3. **Post-Connection (Start server with desired parameters)**:

```bash
python3 solver
```

⚠️ **Security Notice**: Default credentials pose significant risk - change immediately after initial setup!

---

Do you think I should add support for VNC server/protocol for next release?

### 🤔 VNC vs RDP Considerations

**Protocol Comparison**:

| Feature               | RDP                 | VNC                 |
|-----------------------|---------------------|---------------------|
| Performance           | ✅ Optimized         | ⚠️ Bandwidth-heavy  |
| Security              | ✅ Native encryption | 🔄 Depends on setup |
| Cross-Platform        | ✅ Excellent         | ✅ Universal         |
| File Transfer         | ✅ Built-in          | ❌ Requires add-ons  |
| Multi-Monitor Support | ✅ Native            | ✅ Possible          |

```diff
+ For Next Release: Hybrid Support
- Implement both protocols (RDP+VNC) via separate ports
- Add environment variable: PROTOCOL="RDP|VNC" (default: RDP)
- Include VNC password configuration in docker-compose
```

**Suggested Implementation**:

```yaml
# docker-compose.yml
environment:
  - PROTOCOL=${REMOTE_PROTOCOL:-RDP}
  - VNC_PASSWORD=${VNC_PWD:-changeme}
ports:
  - "3389:3389"  # RDP
  - "5900:5900"  # VNC
```
