# my_flutter_app

![](https://i0.wp.com/resocoder.com/wp-content/uploads/2019/08/Clean-Architecture-Flutter-Diagram.png?w=556&ssl=1)

## feature

应用程序的每个“功能”，例如获取有关数字的一些有趣的琐事，都将分为 3 层 -表示层、领域层和数据层。我们正在构建的应用程序将只有一项功能。


## Domain 领域层

域是内层，它不应该受到更改数据源或将我们的应用程序移植到 Angular Dart 的突发奇想的影响。
它将仅包含核心业务逻辑（用例）和业务对象（实体）。
它应该完全独立于其他所有层。

这只是一种奇特的说法，我们创建了一个抽象的Repository类，定义了 Repository 必须执行的操作的契约 - 这进入了领域层。
然后，我们依赖于域中定义的存储库“契约”，知道数据层中存储库的实际实现将履行该契约。

其中的 repositories 是协议

Domain Layer（领域层）通常由 Use Case 和领域模型组成，负责处理应用程序的业务逻辑和核心功能。业务逻辑与UI逻辑不同，UI逻辑定义如何在屏幕上显示内容，而业务逻辑定义如何处理事件和数据更改。

Domain Layer（领域层）不会负责数据的显示，因为这是表现层的工作，也不负责获取和存储数据，这是数据层的工作。


entities 实体
跟业务逻辑相关的类

## Data 层（数据层）

repositories 是实现

我们处于外部世界和我们的应用程序之间的边界，因此我们希望保持简单。
不会有Either<Failure, NumberTrivia>，
而是，我们将只返回一个简单的NumberTriviaModel （从 JSON 转换）。
错误将通过抛出异常来处理。
处理这些“哑”数据并将其转换为Either类型将是Repository的责任。

Data Source 数据源
数据源负责提供应用所需的数据，它们可能是远程API或者本地数据库。

model 模型
以 xxxModel 的形式命名的类，用于表示数据的结构和格式。



## Presentation 表示层

pages 页面
widgets 小部件
bloc: 处理与 domain 层和展示的粘合


## 整洁架构的访问规则
依赖方向：
依赖必须是内向的（从外层指向内层），外层可以依赖内层，但内层绝对不能依赖外层。
各层通过**接口（Interface）或抽象（Abstract）**进行通信。

职责分离：
每一层只关心自己范围内的职责，不能跨层越权。

通信规则：
内层不能直接访问外层，外层通过调用内层的接口完成通信。
数据只能以**数据传输对象（DTO）或值对象（Value Object）**的形式在层间传递。


## 各层职责和通信规则

领域层（Domain Layer）
职责：

负责核心业务逻辑。
包括领域模型（实体和值对象）、领域服务、业务规则。
通信规则：

不依赖其他层。
提供明确的接口（如领域usecase）供应用层调用。
通过 Repository 接口从数据层获取数据（不直接依赖具体实现）。












