# my_flutter_app


![](https://developer.qcloudimg.com/http-save/yehe-170434/3a5066a6fc24ff22f4f5fa0f3a4d6065.jpg)


Core 层：提供全局的基础设施服务（如 NavigationService、Logger、ErrorHandler 等），其他层可以依赖于 Core 层，但 Core 层不依赖任何其他层。

Domain 层：处理核心业务逻辑，如数据处理、验证、计算等。

Data 层：处理数据访问、API 请求、数据库操作等。

Presentation 层：处理与用户界面的交互，如视图更新、页面跳转、UI 逻辑等。路由控制通常在这一层进行，负责根据业务逻辑（可能由 Domain 层 提供）来触发页面跳转。

![](https://i0.wp.com/resocoder.com/wp-content/uploads/2019/08/Clean-Architecture-Flutter-Diagram.png?w=556&ssl=1)

## TODO:

- [ ] 路由管理
- [ ] 主题管理
- [ ] 图片资源管理
- [ ] 国际化

## 各层职责
在整洁架构（Clean Architecture）中，**领域层**、**数据层**和**展示层**各自承担着不同的职责，确保系统高内聚、低耦合并易于维护。以下是每一层的职责和作用：

### **1. 领域层（Domain Layer）**

#### **职责：**
- **核心业务逻辑**：领域层是应用程序的心脏，负责实现应用的核心业务规则和领域模型。所有的复杂计算、业务流程、决策逻辑都应该在领域层进行处理。
- **实体（Entities）**：定义应用程序中的核心数据对象和行为。例如，在电商应用中，`Product`、`Order` 可能是领域实体，包含与业务相关的属性和方法。
- **用例（Use Cases）**：领域层定义了应用程序的用例，它们封装了应用的业务操作。例如，`CreateOrderUseCase`、`CalculateDiscountUseCase`，这些用例将由展示层调用，并与数据层交互。
- **接口**：定义对外部服务（如数据源、API 等）的抽象接口，以保持与外部依赖的解耦。例如，`UserRepository` 接口可以定义数据层应提供的访问方法。

#### **特点：**
- **独立性**：领域层不依赖任何外部库、框架，甚至数据存储方式。它只包含业务逻辑。
- **不与展示层和数据层耦合**：领域层仅通过接口与其他层交互，不关心如何获取或展示数据。

#### **示例：**
```dart
// 领域实体
class Order {
  final int id;
  final List<Product> products;
  final double totalAmount;

  Order(this.id, this.products, this.totalAmount);
}

// 用例
class CalculateTotalAmountUseCase {
  double execute(List<Product> products) {
    return products.fold(0, (sum, product) => sum + product.price);
  }
}
```

---

### **2. 数据层（Data Layer）**

#### **职责：**
- **数据获取与持久化**：数据层负责从外部数据源（如 API、数据库、本地存储等）获取和保存数据。
- **数据转换**：数据层不仅负责获取数据，还需要负责将原始数据转换为领域层可使用的格式。比如，API 返回的数据可能是 JSON 格式，而领域层期望的是 `Order` 实体对象。
- **实现存储接口**：数据层实现领域层定义的存储接口。例如，实现一个 `UserRepository` 接口，通过网络请求或数据库查询来获取用户数据。
- **缓存处理**：在数据层中可以实现缓存策略，以减少不必要的网络请求或数据库查询，提高应用性能。

#### **特点：**
- **具体实现**：数据层直接与外部依赖（如数据库、网络、文件系统）进行交互，具体实现细节对领域层透明。
- **解耦**：领域层定义的数据获取和存储接口，由数据层具体实现。这种方式保持了系统的灵活性和可扩展性。

#### **示例：**
```dart
// 数据层接口
abstract class UserRepository {
  Future<User> getUser(int id);
  Future<void> saveUser(User user);
}

// 数据层实现
class UserRepositoryImpl implements UserRepository {
  final ApiClient apiClient;

  UserRepositoryImpl(this.apiClient);

  @override
  Future<User> getUser(int id) async {
    final response = await apiClient.get('/users/$id');
    return User.fromJson(response.data);
  }

  @override
  Future<void> saveUser(User user) async {
    await apiClient.post('/users', data: user.toJson());
  }
}
```

---

### **3. 展示层（Presentation Layer）**

#### **职责：**
- **UI 展示与交互**：展示层负责渲染应用的用户界面，并处理用户与应用的交互。展示层通过调用领域层的用例来获取数据和执行操作。
- **UI 逻辑与状态管理**：展示层管理 UI 状态的变化，如用户输入、数据加载、错误显示等。它可能会使用状态管理方案（如 `Provider`、`Bloc`、`Riverpod` 等）来响应业务逻辑的变化。
- **用户操作的转发**：展示层接收用户的输入（如按钮点击、表单提交等），并将操作转发给领域层对应的用例处理。
- **UI 组件化**：展示层通常包括不同的 UI 组件（如按钮、列表、对话框等）以及布局管理。每个组件负责其独立的 UI 展示。

#### **特点：**
- **解耦业务逻辑**：展示层不包含业务逻辑，它只关心如何展示数据。所有复杂的业务计算和操作都应通过领域层的用例来完成。
- **状态驱动**：展示层的状态应由领域层返回的数据或者用例执行的结果来驱动。
- **对外暴露 UI 组件**：展示层通常包含诸如视图模型（ViewModel）或者状态管理的工具，用于管理和协调数据流动。

#### **示例：**
```dart
// 展示层：视图模型
class UserViewModel with ChangeNotifier {
  final GetUserUseCase _getUserUseCase;

  User? _user;
  User? get user => _user;

  UserViewModel(this._getUserUseCase);

  Future<void> loadUser(int id) async {
    try {
      _user = await _getUserUseCase.execute(id);
      notifyListeners();
    } catch (e) {
      // 处理错误
    }
  }
}

// 展示层：UI 组件
class UserProfilePage extends StatelessWidget {
  final UserViewModel viewModel;

  UserProfilePage(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserViewModel>(
      create: (_) => viewModel,
      child: Consumer<UserViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.user == null) {
            return CircularProgressIndicator();
          }
          return Text('Hello, ${viewModel.user!.name}');
        },
      ),
    );
  }
}
```

---

### **总结：**

| **层级**      | **职责**                                               | **与其他层的关系**                                   |
|---------------|--------------------------------------------------------|-----------------------------------------------------|
| **领域层**    | - 负责核心业务逻辑<br>- 定义领域模型与用例<br>- 提供接口 | - 不依赖其他层，使用接口与数据层交互，展示层调用用例 |
| **数据层**    | - 数据获取、持久化<br>- 数据转换与存储接口的实现       | - 实现领域层定义的接口，依赖领域层的接口           |
| **展示层**    | - UI 展示与交互<br>- 状态管理与用户输入转发            | - 调用领域层的用例执行操作，展示结果               |

通过整洁架构，领域层、数据层和展示层之间的职责是分离的，它们通过接口进行交互，使得系统易于扩展、测试和维护。展示层主要负责界面和用户交互，领域层处理业务逻辑，数据层则负责数据的持久化和网络通信。

## 参考

- https://resocoder.com/tag/flutter/ 这个Flutter TDD Clean Architecture 系列的文章可以看下，
受益匪浅，思想性的东西通用性很强。
- 整洁架构在前端的设计思想与应用实践：https://cloud.tencent.com/developer/article/2324905

![](https://developer.qcloudimg.com/http-save/yehe-170434/b7968ef5cb008703c5f42b0299c5974e.jpg)

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


## 对第三方组件的二次封装，这种属于哪一层

第三方组件的二次封装通常属于 表示层（Presentation Layer） 或 Core 层，具体取决于该封装的目的和功能

1. 表示层（Presentation Layer）封装
   如果你对第三方组件进行二次封装，目的是为了简化 UI 相关的操作或者让组件更好地与应用的界面逻辑集成，那么这类封装应当属于 表示层。表示层封装第三方组件时，通常是在解决 UI 展示、用户交互或主题等方面的需求。

示例：
UI 控件封装：如果第三方库提供了某种 UI 控件（比如图表、列表等），并且你封装这个控件以便更方便地与应用的界面交互，那么这种封装是表示层的一部分。
主题与样式整合：如果封装目的是为了使第三方组件的样式与应用的整体主题一致（例如，封装 flutter_awesome_dialog 来适配你的应用样式），则它也属于表示层的责任。


2. Core 层封装
如果你对第三方组件进行二次封装，目的是为了提供更统一的接口、简化与其他层的交互，或者做一些基础设施层面的扩展，那么封装应该属于 Core 层。Core 层通常负责管理基础设施服务和通用功能，例如网络请求、数据存储等，而对第三方组件的封装也可能是为了在不同层之间提供一致的接口。

示例：
网络请求库封装：假设你使用了 Dio 来进行网络请求，并且对 Dio 进行二次封装来统一处理 API 调用、错误处理、请求头配置等，这种封装属于 Core 层的责任。
数据库库封装：例如封装 sqflite 或 hive，将其处理方式与应用的存储逻辑解耦，这样的封装属于 Core 层。

3. Domain 层封装
尽管第三方组件的封装一般不会直接放在 Domain 层，但如果封装与业务逻辑密切相关，并且封装后的组件对业务逻辑产生直接影响，那么它也可以考虑放在 Domain 层。

示例：
业务规则封装：如果封装某个第三方库的目的在于简化业务逻辑的处理，例如封装某个计算库来简化数学运算，并直接与业务模型和规则交互，那么它可以放在 Domain 层。


具体实践
通常情况下，第三方库的封装位置依赖于其使用场景：

表示层封装：如果封装目的是简化 UI 交互或与 UI 逻辑的结合，封装应当放在表示层。
Core 层封装：如果封装目的是简化底层服务的调用和管理（如网络请求、数据库、持久化等），封装应放在 Core 层。
Domain 层封装：如果封装是为了简化业务模型的处理，封装可以放在 Domain 层。



## 主题管理（Theme Management）

主题管理主要涉及到用户界面的外观设置，如颜色、字体、样式等，通常由 表示层 来处理。但如果涉及到持久化（如保存用户的主题选择），则可以将相关功能放在 Core 层。

- 表示层（Presentation Layer）：负责主题的切换、主题的展示和用户的交互操作。

例如，通过 UI 控件让用户选择不同的主题（如浅色模式和深色模式），并动态更新应用的外观。

- Core 层：负责持久化和加载用户的主题设置，确保应用能够在启动时恢复用户的主题偏好。

例如，使用 SharedPreferences 来保存用户的主题选择，或使用某种配置文件来管理主题配置。

示例：
表示层：通过 ThemeData 和 ThemeMode 在应用中动态应用不同的主题。
Core 层：通过 ThemeService 来保存和加载用户的主题选择。


## 路由管理（Routing Management）

路由管理是处理页面跳转、导航等 UI 相关的功能。通常，路由管理应该放在 表示层，因为它与用户界面的跳转、页面呈现直接相关。但是，路由可能依赖于 Domain 层 来决定跳转的条件（例如，用户是否登录）。

表示层（Presentation Layer）：主要管理路由和页面跳转的逻辑。通常使用 Navigator 或类似的机制来控制页面跳转。
Core 层：可以提供一个全局的 NavigationService，封装路由的操作，提供统一的接口。表示层会调用 Core 层的路由服务来触发页面跳转。


示例：
表示层：管理路由跳转，基于用户交互触发页面跳转。
Core 层：提供统一的路由服务接口，封装路由逻辑。

## 图片资源管理（Image Resources Management）

图片资源管理主要是管理静态资源（如图片、图标）和可能的动态资源（如网络图片）。通常，图片资源的管理属于 表示层，因为它直接涉及到用户界面显示的内容。但是，图片的下载、缓存等可能涉及到 Core 层。

- 表示层（Presentation Layer）：负责加载和展示图片资源，可能包括本地图片和网络图片。UI 控件（如 Image）和其他 UI 组件都会依赖这些资源来显示内容。
- Core 层：可以封装一些图片缓存、下载和处理的逻辑（例如使用 cached_network_image 来缓存网络图片），从而避免重复的网络请求和资源加载。

示例：
表示层：加载和展示静态图片资源或从网络加载图片。
Core 层：提供图片缓存、下载等服务，避免重复加载资源。


总结
主题管理：主要属于表示层（Presentation Layer），但与 Core 层配合来持久化主题设置。
路由管理：主要属于表示层，但可以通过 Core 层提供全局的路由服务接口来实现解耦。
图片资源管理：大部分属于表示层，但 Core 层可以封装缓存、下载等功能来优化性能和管理资源。


## 事件总线
事件总线是一种基础设施工具，主要用于模块之间的解耦通信。根据其用途和特性，事件总线通常属于 Core 层，因为它作为全局基础设施为应用提供服务。

基础设施
事件总线作为应用的通信机制，与具体业务逻辑无关，它是所有模块都可以依赖的工具。

高复用性
事件总线需要被多个 Feature 使用，而 Core 层正是为了解决这种跨模块的基础功能。

解耦特性
将事件总线放在 Core 层，其他模块通过注入或依赖方式使用，保持架构的低耦合

如何管控事件总线
为了防止事件总线被滥用或造成维护困难，可以通过以下方法进行管理：

1. 明确事件分类
   - 全局事件
    比如用户登录、网络状态变化等全局状态的通知。
   - 局部事件
   比如模块内的状态更新事件，仅限于模块间的通信。

将全局事件和局部事件分开管理，避免事件的无限扩散。







