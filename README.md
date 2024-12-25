# my_flutter_app

![](https://i0.wp.com/resocoder.com/wp-content/uploads/2019/08/Clean-Architecture-Flutter-Diagram.png?w=556&ssl=1)

## feature

应用程序的每个“功能”，例如获取有关数字的一些有趣的琐事，都将分为 3 层 -表示层、领域层和数据层。我们正在构建的应用程序将只有一项功能。


## Domain

域是内层，它不应该受到更改数据源或将我们的应用程序移植到 Angular Dart 的突发奇想的影响。
它将仅包含核心业务逻辑（用例）和业务对象（实体）。
它应该完全独立于其他所有层。

这只是一种奇特的说法，我们创建了一个抽象的Repository类，定义了 Repository 必须执行的操作的契约 - 这进入了领域层。
然后，我们依赖于域中定义的存储库“契约”，知道数据层中存储库的实际实现将履行该契约。

其中的 repositories 是协议


## data 层

repositories 是 实现

我们处于外部世界和我们的应用程序之间的边界，因此我们希望保持简单。不会有Either<Failure, NumberTrivia> ，而是，我们将只返回一个简单的NumberTriviaModel （从 JSON 转换）。错误将通过抛出异常来处理。处理这些“哑”数据并将其转换为Either类型将是Repository的责任。