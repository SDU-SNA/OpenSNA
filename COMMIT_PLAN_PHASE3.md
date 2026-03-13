# Phase 3 提交计划 - 更新版本

## 提交原则

1. **原子性**: 每个提交只包含一个逻辑单元
2. **清晰性**: 提交消息清晰描述改动内容
3. **中文**: 提交消息使用中文
4. **顺序**: 按照开发顺序提交

---

## 当前状态（2026-03-11）

### 已完成工作 ✅

**feature_network_service 包（75% 完成）**:
- ✅ 包结构创建
- ✅ 4个数据模型（NetworkAccount, DeviceInfo, SpeedTestResult, RepairRecord）
- ✅ NetworkServiceApi 数据源（20+ 个 API 方法）
- ✅ NetworkRepository 接口和实现
- ✅ NetworkProviders 状态管理（10+ 个 Provider）
- ✅ SpeedTestPage 网络测速页面
- ✅ NetworkAccountPage 网络账号管理页面
- ✅ DeviceManagePage 在线设备管理页面
- ✅ JSON 序列化代码生成（.g.dart 文件）

### 待提交的更改

**新增文件**:
- `docs/phase3_progress.md` - Phase 3 开发进度文档
- `docs/phase3_day1_summary.md` - Phase 3 Day 1 完成总结
- `packages/features/feature_network_service/` - 完整的包（所有文件）
- `packages/toolkit/` - 新增 Toolkit 包（6个）

**修改文件**:
- `CHANGELOG.md` - 添加 v0.3.0 内容
- `COMMIT_PLAN.md` - 更新提交计划
- `docs/DEVELOPMENT_PROGRESS.md` - 添加 Phase 3 进度
- `packages/core/core_storage/pubspec.yaml` - 依赖更新
- `packages/features/feature_auth/pubspec.yaml` - 依赖更新

---

## 提交计划（按顺序）

### Commit 1: 创建 feature_network_service 包结构

**文件**:
- `packages/features/feature_network_service/pubspec.yaml`
- `packages/features/feature_network_service/README.md`

**提交消息**:
```
feat(network-service): 创建 feature_network_service 包

- 创建包结构和配置文件
- 配置依赖（core层、riverpod、json_annotation等）
- 编写完整的 README 文档
- 注释 network_diagnostic_kit 依赖（网络问题）
```

---

### Commit 2: 添加数据模型

**文件**:
- `packages/features/feature_network_service/lib/src/data/models/network_account.dart`
- `packages/features/feature_network_service/lib/src/data/models/device_info.dart`
- `packages/features/feature_network_service/lib/src/data/models/speed_test_result.dart`
- `packages/features/feature_network_service/lib/src/data/models/repair_record.dart`

**提交消息**:
```
feat(network-service): 添加数据模型

- NetworkAccount: 网络账号信息模型
- DeviceInfo: 在线设备信息模型
- SpeedTestResult: 网络测速结果模型（含质量评级算法）
- RepairRecord: 故障报修记录模型
- 所有模型支持 JSON 序列化
- 添加计算属性和格式化方法
```

---

### Commit 3: 添加数据源和 Repository

**文件**:
- `packages/features/feature_network_service/lib/src/data/datasources/network_service_api.dart`
- `packages/features/feature_network_service/lib/src/domain/repositories/network_repository.dart`
- `packages/features/feature_network_service/lib/src/data/repositories/network_repository_impl.dart`

**提交消息**:
```
feat(network-service): 添加数据源和 Repository

- NetworkServiceApi: 网络服务 API（20+ 个方法）
  - 网络账号管理 API
  - 在线设备管理 API
  - 网络测速 API
  - 故障报修 API
- NetworkRepository: Repository 接口定义
- NetworkRepositoryImpl: Repository 实现
```

---

### Commit 4: 添加状态管理

**文件**:
- `packages/features/feature_network_service/lib/src/presentation/providers/network_providers.dart`

**提交消息**:
```
feat(network-service): 添加 Riverpod 状态管理

- 依赖注入 Provider（ApiClient、Api、Repository）
- 网络账号 Provider（账号信息、流量历史）
- 在线设备 Provider（设备列表、设备详情、设备管理）
- 网络测速 Provider（测速、测速历史、服务器列表）
- 故障报修 Provider（提交报修、报修记录、评价）
- 10+ 个 Provider 和 Notifier
```

---

### Commit 5: 添加网络测速页面

**文件**:
- `packages/features/feature_network_service/lib/src/presentation/pages/speed_test_page.dart`

**提交消息**:
```
feat(network-service): 添加网络测速页面

- SpeedTestPage: 网络测速页面
  - 空闲状态（未开始测速）
  - 测速中状态（加载动画）
  - 测速结果状态（质量评级、速度指标、网络指标）
  - 错误状态（错误提示、重试）
- Material Design 3 设计
- 响应式 UI
```

---

### Commit 6: 添加网络账号管理页面

**文件**:
- `packages/features/feature_network_service/lib/src/presentation/pages/network_account_page.dart`

**提交消息**:
```
feat(network-service): 添加网络账号管理页面

- NetworkAccountPage: 网络账号管理页面
  - 账号信息卡片（用户名、状态、到期时间）
  - 余额卡片（显示余额、充值按钮）
  - 流量统计卡片（进度条、已用/剩余流量）
  - 套餐信息卡片（套餐名称、价格、流量）
  - 快捷操作（流量历史、消费记录、套餐管理）
  - 充值对话框（快捷金额选择）
  - 下拉刷新支持
- Material Design 3 设计
- 响应式 UI
- 状态标签（正常/停用/已过期）
- 即将到期提醒
```

---

### Commit 7: 添加在线设备管理页面

**文件**:
- `packages/features/feature_network_service/lib/src/presentation/pages/device_manage_page.dart`

**提交消息**:
```
feat(network-service): 添加在线设备管理页面

- DeviceManagePage: 在线设备管理页面
  - 设备统计（在线设备数、总流量）
  - 设备列表（卡片式展示）
  - 设备详情（底部抽屉）
  - 设备下线功能（确认对话框）
  - 当前设备标识
  - 设备图标（根据类型显示）
  - 在线时长和流量显示
  - 下拉刷新支持
- Material Design 3 设计
- 响应式 UI
- 完整的设备信息展示
```

---

### Commit 8: 生成 JSON 序列化代码

**文件**:
- `packages/features/feature_network_service/lib/src/data/models/*.g.dart`

**提交消息**:
```
build(network-service): 生成 JSON 序列化代码

- 运行 build_runner 生成 .g.dart 文件
- 所有数据模型的 JSON 序列化代码
```

---

### Commit 9: 更新主导出文件

**文件**:
- `packages/features/feature_network_service/lib/feature_network_service.dart`

**提交消息**:
```
feat(network-service): 更新主导出文件

- 导出所有数据模型
- 导出 API 和 Repository
- 导出状态管理 Provider
- 导出所有页面（SpeedTestPage, NetworkAccountPage, DeviceManagePage）
```

---

---

### Commit 10: 更新依赖配置

**文件**:
- `packages/core/core_storage/pubspec.yaml`
- `packages/features/feature_auth/pubspec.yaml`

**提交消息**:
```
chore: 更新依赖配置

- 更新 core_storage 依赖
- 更新 feature_auth 依赖
- 确保所有包依赖版本一致
```

---

### Commit 11: 更新 Phase 3 文档

**文件**:
- `docs/phase3_progress.md`
- `docs/phase3_day1_summary.md`
- `docs/DEVELOPMENT_PROGRESS.md`
- `CHANGELOG.md`
- `COMMIT_PLAN.md`

**提交消息**:
```
docs: 更新 Phase 3 开发文档

- 创建 phase3_progress.md（Phase 3 开发进度）
- 创建 phase3_day1_summary.md（Day 1 完成总结）
- 更新 DEVELOPMENT_PROGRESS.md（添加 Phase 3 进度）
- 更新 CHANGELOG.md（添加 v0.3.0 内容）
- 更新 COMMIT_PLAN.md（更新提交计划）
```

---

## 提交顺序总结

1. ✅ 创建包结构
2. ✅ 添加数据模型
3. ✅ 添加数据源和 Repository
4. ✅ 添加状态管理
5. ✅ 添加网络测速页面
6. ✅ 添加网络账号管理页面
7. ✅ 添加在线设备管理页面
8. ✅ 生成 JSON 序列化代码
9. ✅ 更新主导出文件
10. ✅ 添加 Toolkit 包
11. ✅ 更新依赖配置
12. ✅ 更新 Phase 3 文档

---

## 注意事项

1. 每个提交前检查代码质量
2. 确保提交消息清晰准确
3. 遵循原子性原则
4. 按照顺序提交
5. 提交后验证代码可以正常运行
6. Toolkit 包作为子模块，需要单独维护
7. 网络问题导致的依赖注释需要后续解决

---

**创建时间**: 2026-03-11  
**最后更新**: 2026-03-11  
**状态**: 准备提交 🚀
