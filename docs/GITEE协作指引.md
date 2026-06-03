# Gitee 协作指引

本文档说明如何参与 [write-sql](https://gitee.com/azqbozi/write-sql) 项目。

## 协作模式说明

本项目采用 **Fork + Pull Request（PR）** 流程：

| 角色 | 说明 |
|------|------|
| **管理员** | 仓库所有者，负责审核 PR、决定是否合并 |
| **贡献者** | 其他 Gitee 用户，Fork 仓库后提交改动，**不能直接推送到主仓库** |

```text
主仓库（azqbozi/write-sql）
    ↑
    │  Pull Request（需管理员审核合并）
    │
你的 Fork（你的用户名/write-sql）
    ↑
    │  git push
    │
本地电脑
```

**重要**：所有新增内容必须先通过 PR 提交，经管理员审核同意后才会合并到主仓库。

---

## 一、准备工作

### 1.1 注册 Gitee 账号

1. 打开 [https://gitee.com](https://gitee.com) 注册账号
2. 完成邮箱验证（建议开启双因素认证）

### 1.2 安装 Git

- Windows：下载 [Git for Windows](https://git-scm.com/download/win)，安装时保持默认选项即可
- 安装完成后，打开 **PowerShell** 或 **Git Bash**，验证：

```bash
git --version
```

### 1.3 配置 Git 用户信息（首次使用必做）

```bash
git config --global user.name "你的昵称"
git config --global user.email "你的Gitee绑定邮箱"
```

### 1.4 生成私人令牌（HTTPS 推送必用）

若账号开启了双因素认证，**不能使用登录密码推送**，必须使用私人令牌。

1. 登录 Gitee → 右上角头像 → **设置**
2. 左侧 **安全设置** → **私人令牌**
3. 点击 **生成新令牌**，勾选 **`projects`（仓库权限）**
4. 复制令牌并妥善保存（只显示一次）

> 后续 `git push` 时，密码处粘贴此令牌。

---

## 二、贡献者：第一次参与

### 2.1 Fork 主仓库

1. 打开主仓库：<https://gitee.com/azqbozi/write-sql>
2. 点击右上角 **Fork**
3. 选择 Fork 到你自己的账号下

Fork 完成后，你会有自己的仓库，地址形如：

```text
https://gitee.com/你的用户名/write-sql
```

### 2.2 克隆到本地

```bash
# 将「你的用户名」替换为你的 Gitee 用户名
git clone https://gitee.com/你的用户名/write-sql.git
cd write-sql
```

### 2.3 关联上游仓库（推荐）

便于后续同步主仓库的最新代码：

```bash
git remote add upstream https://gitee.com/azqbozi/write-sql.git
git remote -v
```

预期输出示例：

```text
origin    https://gitee.com/你的用户名/write-sql.git (fetch/push)  ← 你的 Fork
upstream  https://gitee.com/azqbozi/write-sql.git (fetch/push)    ← 主仓库
```

---

## 三、贡献者：日常修改与提交

### 3.1 同步主仓库最新代码（开始工作前建议执行）

```bash
git fetch upstream
git checkout main
git merge upstream/main
git push origin main
```

### 3.2 新建功能分支（推荐）

不要直接在 `main` 上改，便于 PR 审查：

```bash
git checkout -b feature/你的改动简述
```

分支命名示例：

- `feature/add-table-069-doc`
- `fix/routing-typo`
- `docs/update-metric-index`

### 3.3 修改文件并提交

```bash
# 查看改了哪些文件
git status

# 添加要提交的文件
git add .

# 提交（写清楚做了什么）
git commit -m "docs: 补充 069 表结构文档"
```

Commit 说明建议：

- 用中文或英文均可，但要**说清改了什么**
- 可加前缀：`docs:`、`feat:`、`fix:`

### 3.4 推送到你的 Fork

```bash
git push -u origin feature/你的改动简述
```

首次 push 会要求登录：

- **用户名**：Gitee 用户名
- **密码**：私人令牌（不是登录密码）

---

## 四、贡献者：发起 Pull Request

推送成功后，在 Gitee 网页操作：

1. 打开 **你的 Fork** 仓库页面
2. 通常会看到提示 **「Compare & Pull Request」**，点击；或手动进入主仓库 → **Pull Requests** → **新建 Pull Request**
3. 源仓库选：**你的用户名/write-sql** + 你的分支
4. 目标仓库选：**azqbozi/write-sql** + `main`
5. 填写 PR 标题和说明，例如：
   - 改了什么
   - 为什么改
   - 是否影响现有 SQL 口径
6. 点击 **创建 Pull Request**

创建后等待管理员审核，**请勿自行合并**。

---

## 五、贡献者：PR 合并后同步本地

PR 被管理员合并后，更新本地：

```bash
git checkout main
git fetch upstream
git merge upstream/main
git push origin main
```

可删除已合并的本地分支：

```bash
git branch -d feature/你的改动简述
```

---

## 六、管理员：审核与合并 PR

> 本节供仓库管理员（`azqbozi`）参考。

### 6.1 收到 PR 后

1. 打开 <https://gitee.com/azqbozi/write-sql/pulls>
2. 点开待审核的 PR
3. 查看 **Files changed（文件变更）**
4. 必要时在评论区与贡献者沟通

### 6.2 合并 PR

确认无误后：

1. 点击 **合并 Pull Request**
2. 选择合并方式（一般选 **创建合并 commit** 即可）
3. 确认合并

### 6.3 拒绝或要求修改

若改动不符合要求：

1. 在 PR 下留言说明原因
2. 点击 **关闭 Pull Request** 或等待贡献者修改后重新 push（同一 PR 会自动更新）

---

## 七、常见问题

### Q1：push 时报 403 / 认证失败

- 确认使用的是 **私人令牌**，不是登录密码
- 令牌需包含 `projects` 权限
- 重新生成令牌后再 push

### Q2：无法 push 到 `azqbozi/write-sql`

这是正常现象。贡献者**只能 push 到自己的 Fork**，不能直接 push 主仓库。请走 Fork → PR 流程。

### Q3：PR 提示有冲突（Conflict）

在主仓库已有新提交时可能发生。贡献者在本地执行：

```bash
git fetch upstream
git checkout feature/你的改动简述
git merge upstream/main
# 手动解决冲突后
git add .
git commit -m "merge: 解决与 upstream 的冲突"
git push origin feature/你的改动简述
```

### Q4：clone 很慢或失败

- 检查网络
- 可尝试 SSH 方式（见附录）

---

## 附录 A：SSH 方式（可选）

若不想每次输入令牌，可配置 SSH：

```bash
# 生成密钥（一路回车即可）
ssh-keygen -t ed25519 -C "你的邮箱"

# 查看公钥，复制全部内容
cat ~/.ssh/id_ed25519.pub
```

1. Gitee → **设置** → **SSH 公钥** → 粘贴公钥并保存
2. 修改远程地址：

```bash
git remote set-url origin git@gitee.com:你的用户名/write-sql.git
git remote set-url upstream git@gitee.com:azqbozi/write-sql.git
```

之后 `git push` 不再需要输入令牌。

---

## 附录 B：命令速查

| 场景 | 命令 |
|------|------|
| 首次 Fork 后克隆 | `git clone https://gitee.com/你的用户名/write-sql.git` |
| 关联主仓库 | `git remote add upstream https://gitee.com/azqbozi/write-sql.git` |
| 同步主仓库 | `git fetch upstream && git merge upstream/main` |
| 新建分支 | `git checkout -b feature/xxx` |
| 提交 | `git add . && git commit -m "说明"` |
| 推送到 Fork | `git push -u origin feature/xxx` |
| 发起 PR | 在 Gitee 网页创建 Pull Request |

---

## 相关链接

- 主仓库：<https://gitee.com/azqbozi/write-sql>
- Gitee 私人令牌：<https://gitee.com/profile/personal_access_tokens>
- Gitee PR 帮助：<https://gitee.com/help/articles/4129>
