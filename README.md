# fleamarket
1，在iphone 深色模式下，状态栏字体颜色始终为白色的bug
解决：在XCode工程中，AppDelegate.swift文件中加入以下代码

let kOverlayStyleUpdateNotificationName = "io.flutter.plugin.platform.SystemChromeOverlayNotificationName"
let kOverlayStyleUpdateNotificationKey = "io.flutter.plugin.platform.SystemChromeOverlayNotificationKey"

extension FlutterViewController {
    private struct StatusBarStyleHolder {
        static var style: UIStatusBarStyle = .default
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appStatusBar(notification:)),
            name: NSNotification.Name(kOverlayStyleUpdateNotificationName),
            object: nil
        )
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return StatusBarStyleHolder.style
    }
    
    @objc private func appStatusBar(notification: NSNotification) {
        guard
            let info = notification.userInfo as? Dictionary<String, Any>,
            let statusBarStyleKey = info[kOverlayStyleUpdateNotificationKey] as? Int
        else {
            return
        }
        
        if #available(iOS 13.0, *) {
            StatusBarStyleHolder.style = statusBarStyleKey == 0 ? .darkContent : .lightContent
        } else {
            StatusBarStyleHolder.style = statusBarStyleKey == 0 ? .default : .lightContent
        }
        
        setNeedsStatusBarAppearanceUpdate()
    }
}

2，在使用 Material 相关部件（如TextField）配合Hero动画过渡时，出现 No Material widget found. 错误
解决：在Hero子级中，使用Material再包装一层
https://github.com/flutter/flutter/issues/34119

3，类似react state/props 在数据未更新完成操作 state 中的数据引发的问题，如在TextFiled中使用按钮来清空文本引发的异常
invalid text selection: TextSelection(baseOffset: 4, extentOffset: 4, affinity: TextAffinity.upstream, isDirectional: false)
解决：暂时使用延时来清空文本

4，使用Material风格情况下，许多可点击的部件，触发点击会出现水波纹效果
解决：要关闭全部水波纹效果，在main的主题里加入；若只修改本部分，则在使用的地方加入主题并写入
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,

5，对于实现SingleTickerProviderStateMixin 的tabbar，无法动态更新TabController长度
解决：将SingleTickerProviderStateMixin 改为 TickerProviderStateMixin

6，默认状态的TabView最多保留两个view的缓存，将TabView的子页实现AutomaticKeepAliveClientMixin，并重写wantkeeplive返回true，即可实现当前view
的缓存（如果后面页面内容过多导致内存问题，再解决）

7，WaterfallItem 初次挂载的时候，会先把文字内容显示出来（因为图片是在后面才请求到），这时候就会出现文字，等一会才会出现图片

8，bottomNavigationBar 切换导致上一个页面状态丢失的情况，使用IndexedStack方案解决

9，在当前的main页面代码中，使用Navigator做跳转的时候出现 Navigator operation requested with a context that does not include a Navigator.
原因是 MyApp实际上是MaterialApp的父级。实例化MaterialApp的是小部件！因此，MyApp的BuildContext没有MaterialApp作为父项！
解决：https://stackoverflow.com/questions/44004451/navigator-operation-requested-with-a-context-that-does-not-include-a-navigator?answertab=active#tab-top

10，使用easyRefresh组件包裹tabview内容时，切换未加载的view导致上一个view回到顶部的bug，是因为NestedScrollView的特殊性，几个EasyRefresh会公用一个ScrollController
暂时用回原来方式

11，为使用自定义键盘，在TextField中需要禁止弹出系统键盘
解决：源码 TextField, EditableText增加字段 disableKeyboard
     在EditableText中修改TextInputConfiguration 引入字段disableKeyboard
     在TextInput中修改TextInputConfiguration类 加入字段disableKeyboard
     最后在TextInput的TextInputConnection类中 修改show函数 加入判断TextInput._instance._currentConfiguration?.disableKeyboard

12，在完成自定义键盘时，发现预先绘制好widget 比每次打开重新build要快很多，特别是像自定义键盘这样比较复杂的ui

13，android平台ScrollView类型的容器，到顶下拉或到底上拉动作，出现水波纹效果
解决：不想使用使用此效果，修改源码GlowingOverscrollIndicator 定义的 showLeading 和 showTrailing
由于目前项目中完全不使用这样的水波效果，所以直接把这里改为false，更多相关信息，可以查看ScrollConfiguration的buildViewportChrome

14，InkWell水波纹效果无效情况
解决：使用Material包裹元素，不要指定子元素color属性（如果有），这也会导致水波纹无效，需要的背景色在Material中指定
# ====================================== 已废弃 因为使用的对象并不多，并且对于自定义，明显手动配置更方便
model文件与json类型互相转，使用json_serializable包生成
示例参考models/user类
项目根路径执行 flutter packages pub run build_runner build

# ====================================== 状态管理
状态管理经研究了flutter_redux和provider之后，选定使用provider
redux经查几个示例来看，构建action过于繁复，多store组合多方式也不完整
相比之下provider提供了多种类型的provider（虽然redux在middleware的帮助下也能实现类似效果）
并且对于组合嵌套上和子状态管理上比redux更为健全

使用新建实例 *Provider.#create
使用已有实例 *Provider.#value

provider根据BuildContext为基准向上查找最靠近的父级，并不是以组件的上下级关系确定，所以相连的父子组件需要维护状态，需要用到consumer和selector
作为全局状态（换页）时，需要在app这一级别使用

Provider.of(context) 会将该context（也就是传入级的context）的作用域全部刷新
使用 consumer 或 selector（可控是否刷新区域）来仅刷新部分区域

Consumer<T>
    T为可能找到的上一级的provider实例类型
Selector<A,S>
    A为可能找到的上一级的provider实例类型
    S为当前需要的类型，在selector: (context, provider) 返回该类型，此后builder和shouldRebuild的pre和next都将使用此类型

selector 中需要做shouldRebuild判断的值，仅对指定的值有效
在main中，本想直接使用provider对象，靠取对象的多个属性来做更新判断，结果发现直接指定provider的话，provider的某属性的值只会是更新后的结果，
所以这样是无法进行shouldRebuild判断，解决方法是指定集合类型来选择多个值，这里使用了tuple 元祖库的类型来处理

# ===================================== 架构
https://medium.com/flutter-community/flutter-provider-v3-architecture-using-proxyprovider-for-injection-62cf5c58ea52
https://medium.com/flutter-community/making-sense-all-of-those-flutter-providers-e842e18f45dd
翻译+理解
架构概述
Before we start I want to outline the things that I’d like this architecture to accomplish outside of the basics like, maintainable, easy to understand, well separated etc. Here are some of the things to keep in mind while developing using this architecture.
在我们开始之前，我想概述一下我希望这个架构在基础之外完成的事情，比如，可维护性，容易理解，良好的分离等。在开发使用这种体系结构时，要记住以下几点。

Every “group”/”collection” of widgets that relies on logic will be made into its own widget with its own ViewModel.
依赖逻辑的小部件的每个“组” /“集合”都将通过自己的ViewModel制成自己的小部件。

If a view has a Model the only purpose of that model will be to show different states of the view UI. Another way to look at this is by saying. A view shouldn’t re-render if a small change has occurred that doesn’t affect the entire view. If it does then you have to pull that UI that changes into its own widgets with its own model.
如果视图具有模型，则该模型的唯一目的是显示视图UI的不同状态。看这个的另一种方式是说。如果发生了不影响整个视图的微小更改，则不应重新渲染视图。如果是这样，则您必须将更改的UI拖入具有自己的模型的自己的小部件中。

No business logic in the UI (file). I consider the UI being the file that defines the Widgets and layout. The ViewModel is not part of the UI
UI（文件）中没有业务逻辑。我认为UI是定义Widget和布局的文件。ViewModel不属于UI

All logic and state management happens in the ViewModel
所有逻辑和状态管理都在ViewModel中进行

The ViewModel will not implement any specific functionality. Instead, it will make use of dedicated services that group functionality together based on the app’s requirements. We’ll use the Single Responsibility Principle to a moderate degree here.
Single Responsibility will be used for defining services, but not the way some people have misused it. We’ll do it based on this quote from Robert Martin.
“Gather together the things that change for the same reasons. Separate those things that change for different reasons.”
ViewModel将不会实现任何特定功能。相反，它将使用专用服务，这些服务根据应用程序的需求将功能分组在一起。在这里，我们将适度使用“单一责任原则”。
单一职责将用于定义服务，而不是某些人滥用它的方式。我们将根据罗伯特·马丁（Robert Martin）的这句话来做。
“收集那些因为同样的原因而改变的事情。把那些因不同原因而改变的事情分开。”

Create dedicated services to do all the actual work based on what’s said above
根据上述内容创建专门的服务来完成所有实际工作

Models will reduce state based on information in the shared service
模型将基于共享服务中的信息来减少状态


这就是要牢记的事情。您可以在此处下载开始的项目zip，或在此处克隆我的真棒教程回购，然后跟随教程014。该项目已设置了一些基本内容，因此我们不关注体系结构之外的任何内容。已经设置的一些东西是：
应用程序的颜色和文字样式
api类从jsonPlaceholder获取并序列化API数据
具有用户控制器并使用API​​执行“登录”的身份验证服务
API序列化的数据模型
空主页，登录和帖子视图
LoginHeader（文本和输入字段），PostListItem（带有手势检测器的容器）和Comment（空，但还定义了Comment列表项）的小部件UI
像这样的命名路由的路由器设置


view model 一般的model为数据模型，这个是页面状态的模型


拓展架构

将viewModel的service注入移到viewModel 内部构建，因为拓展baseViewModel时，考虑到全局弹窗到便捷性，所以传入了context
这样就没必要在每个viewModel的构造函数中写入多个参数

# keystore
flea12346mart

# InkWell 和 GestureDetector 区别
根据官方描述来看，GestureDetector专注手势的使用，支持多种手势；而InkWell更专注于app常用的点击类型的手势。
经过使用发现，如果仅是想实现普通点击类型的手势操作，最好使用InkWell，因为GestureDetector的事件，仅会作用
在包裹内容中有效展示的内容，比如在一个容器中，左边展示了文字，而右边是一个空的区域，这时候就算GestureDetector包裹的区域
足够大，对于右边区域事件也不会响应；相比InkWell，它的事件响应在包裹内容的任何位置都是有效的。
另外，对于多视图叠加的情况，GestureDetector好像是会覆盖底层的事件，这就避免了事件冒泡的问题

# 发布
发布的build版本可在pubspec.yaml中指定

切记xcode中项目displaname Runner 不要去改，否则项目无法本地调试运行了

## ios
注意一定要用xcode选择Runner.xcworkspace，否则在调用一些静态库时（如本项目集成的高度地图）会发生库无法找到的问题
同时选择Run目标为Generic IOS device

1.修改pubspec.yaml 的版本和build版本，不要在xcode中去修改，导致两边数据不统一，如version: 0.1.0+5 为主版本0.1.0 第5个build版本
2.flutter build ios 编译ios包
3.Xcode 打开项目路径下.../myApp/ios/Runner.xcworkspace
4.Xcode Product > Archive
5.Archive 成功后在弹出的archive管理页中，直接分发到App Store Connect
6.等待审核
7.审核通过后在TF的TestFlight构建版本中，找到当前发布的构建版本，可能缺少出口标示，点击黄色警告选下一步完成

因为permission_handle库的原因，它默认将最多可用权限全部开启，导致审核的时候，明明没有使用到的权限，也会被苹果静态检测出来，
根据库的描述，在ios/Podfile中修改配置
...
config.build_settings['ENABLE_BITCODE'] = 'NO'
... 此后加入
config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
    '$(inherited)', 
    'PERMISSION_EVENTS=0',
    'PERMISSION_SENSORS=0',
    'PERMISSION_MEDIA_LIBRARY=0',
    'PERMISSION_SPEECH_RECOGNIZER=0',
    'PERMISSION_CONTACTS=0',
    'PERMISSION_NOTIFICATIONS=0'
]
相关权限对应健
PermissionGroup.calendar | NSCalendarsUsageDescription | PERMISSION_EVENTS | | 
PermissionGroup.reminders | NSRemindersUsageDescription | PERMISSION_REMINDERS | | 
PermissionGroup.contacts | NSContactsUsageDescription | PERMISSION_CONTACTS | | 
PermissionGroup.camera | NSCameraUsageDescription | PERMISSION_CAMERA | | 
PermissionGroup.microphone | NSMicrophoneUsageDescription | PERMISSION_MICROPHONE | | 
PermissionGroup.speech | NSSpeechRecognitionUsageDescription | PERMISSION_SPEECH_RECOGNIZER | | 
PermissionGroup.photos | NSPhotoLibraryUsageDescription | PERMISSION_PHOTOS | | 

PermissionGroup.location, PermissionGroup.locationAlways, PermissionGroup.locationWhenInUse | NSLocationUsageDescription, NSLocationAlwaysAndWhenInUseUsageDescription, NSLocationWhenInUseUsageDescription | PERMISSION_LOCATION | | 

PermissionGroup.notification | PermissionGroupNotification | PERMISSION_NOTIFICATIONS | | 
PermissionGroup.mediaLibrary | NSAppleMusicUsageDescription, kTCCServiceMediaLibrary | PERMISSION_MEDIA_LIBRARY | | 
PermissionGroup.sensors | NSMotionUsageDescription | PERMISSION_SENSORS |

http://www.bitsflea.com
http://www.bitsflea.com/img57.png
http://www.bitsflea.com/img512.png



5JTjhoW4cbBDcHkfDVE6C3DwHqgU4yccqTAxrV7xc7JMDwa1xja
EOS6RbTLtFQ49MKa8epucQT7FvTjcCHgLc58FzY9mcPVcN94omxtT
70183925
e4c04a6f07836994913cdf79cdab42bb
