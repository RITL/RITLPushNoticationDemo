# RITLPushNoticationDemo
A demo To learn UserNotifications and Extension .

iOS10发布以来，相信各位开发者能踩的坑也应该踩得差不多了；但也许正是因为每次苹果都会更新比较多的东西，才会觉得搞iOS很有意思吧。（不知道大家会不会觉得楼主这种想法有点坑?）

推送是iOS10系统变动比较大的一个地方，对于这种大变动不瞅瞅一下着实不符合楼主的性格，那么楼主就在求知欲的推动下(毕竟还得给自己的项目进行适配不是..)就花了点时间对UserNotifications这个框架进行了一个整体的了解，希望在这里记录一下，希望能够帮助对这个框架有兴趣的小伙伴。

如果大家的项目中推送是使用了极光、友盟等第三方推送，那么请根据他们的官方文档以及最新的SDK对iOS10进行适配即可，跟着文档一步一步走也比较简单。但是如果想要真实的了解原框架的流程，建议还是使用原生推送吧，楼主本文博客下使用的就是原生推送。

如何配置原生推送，推荐[有梦想的蜗牛 一步一步教你做ios推送](http://blog.csdn.net/showhilllee/article/details/8631734)，这位博主写的很详细，虽然开发者界面已经不是那样子了，但实质的东西还是没有变化的。如果按照推荐博文的配置<font color=orange>(!一定要确认所有的配置都没有问题!)</font>，但依旧收不到远程推送，那么估计就和楼主一样“中奖”了，可能是PHP端交互出问题了，这个时候推荐大家使用[PushMeBody](https://github.com/stefanhafeneger/PushMeBaby)来完成远程推送。<font color=orange>(使用PushMesBody中的device token直接复制打印的device token即可，不需要去掉空格)</font>

为了能够区分它与之前用法的异同，楼主还是尽可能的想通过比较的方法实现推送的相关功能。
如果有什么问题，也请及时指出，共同进步，感谢。
<br>
#推送的注册

注册的位置没有任何的变化，是在Appdelegate中的`-application: didFinishLaunchingWithOptions:`方法里面进行注册，楼主为了简化它的代码，将注册功能封装成了一个`RITLNotificationManager`类，所以该方法下只需一句话即可:
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化个数
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //注册所有的推送
    [[RITLNotificationManager sharedInstance]registerRemoteNotificationsApplication:self];

    return YES;
}
```
<br>
##注册具体代码实现

RITLNotificationManager的声明<font color=red>(楼主在声明文件中使用了预编译进行方法的声明，实际的开发中建议不要这么写，将方法分开便是，不同的版本使用不同的方法即可)</font>以及实现方法如下:
```
//RITLNotificationManager.h（实际Demo中它在"RITLOriginPushAppDelegate+RITLNotificationManager.h"文件下）

/// 注册远程推送
#ifdef __IPHONE_10_0
- (void)registerRemoteNotificationsApplication:(id<UNUserNotificationCenterDelegate>)application;
#else
- (void)registerRemoteNotificationsApplication:(id)application;
#endif
```
```
//RITLOriginPushAppDelegate+RITLNotificationManager.m

#ifdef __IPHONE_10_0
-(void)registerRemoteNotificationsApplication:(id<UNUserNotificationCenterDelegate>)application
#else
- (void)registerRemoteNotificationsApplication:(id)application
#endif
{
#ifdef __IPHONE_10_0

    //设置代理对象
    [UNUserNotificationCenter currentNotificationCenter].delegate = application;
    
    // 请求权限
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted == true)//如果准许，注册推送
        {
            [[UIApplication sharedApplication]registerForRemoteNotifications];
        }  
    }];

#else
    
#ifdef __IPHONE_8_0 //适配iOS 8
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
    
    [[UIApplication sharedApplication]registerForRemoteNotifications];
    
#else //适配iOS7
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
#endif
    
#endif
}
```
<br>
##注册完毕进行的回调
这一部分iOS10没有发生变化，还是和之前一样，分为注册成功以及注册失败两个协议方法，方法就在类别`RITLOriginPushAppDelegate+RITLNotificationManager`:
```
// 注册推送成功
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //    NSLog(@"token = %@",deviceToken);
    // 将返回的token发送给服务器
}

// 注册推送失败
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"remoteNotice failture = %@",error.localizedDescription);
}
```
<br>
#UserNotifications以前接收推送消息

在Demo中对AppDelegate新建了一个类别`"RITLOriginPushAppDelegate+RITLOldNotification"`来完成对之前推送消息的接收以及处理:
```
//通过点击远程推送进入App执行的方法,不管是应用被杀死还是位于后台
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //收到的信息
    NSLog(@"%@",[[userInfo valueForKey:@"aps"] valueForKey:@"alert"]);
    
    [self performSelector:NSSelectorFromString(@"__showAlert:") withObject:@"通过点击推送进入App" afterDelay:0];
}
```
```
// 在前台收到远程推送执行的方法,如果实现了iOS10的协议方法，该方法不执行,虽然没有标明废弃
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    //这个时候不会弹出推送，通常，在此处进行一次本地推送，进行通知
    //coding..
    
    //回调
    completionHandler(UIBackgroundFetchResultNewData);
}
```
```
// 收到本地推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //coding to handle local notification
    NSLog(@"本地推送啦!");
    
    //获得文本与详细内容
    NSString * content = [NSString stringWithFormat:@"本地通知:title = %@, subTitle = %@",notification.alertBody,notification.alertTitle];
    
    [self performSelector:NSSelectorFromString(@"__showAlert:") withObject:content afterDelay:1];
}
```
<br>
#UserNotifications下的接收推送消息

由于UserNotifications不再对远程推送以及本地推送进行区分，所以只需实现`UNUserNotificationCenterDelegate`协议下的两个协议方法即可，楼主是将该方法写在了AppDelegate的另一类别中`RITLOriginPushAppDelegate+RITLUserNotifications`：
```
#pragma mark - <UNUserNotificationCenterDelegate>

// 在前台收到通知时，将要弹出通知的时候触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    //比如如果App实在前台，就不需要Badge了
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    }
    
    else//如果是后台或者不活跃状态，需要badge
    {
        //需要三种弹出形式,如果存在Alert,那么App在前台也是可以从上面弹出的
        completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    }
}
```
```
// 已经收到通知响应的处理方法，不管是什么通知，当通过点击推送进入或者回到App的时候触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    //获得响应对象
    UNNotification * notification = response.notification;
    
    //获得响应时间
//    NSDate * responseDate = notification.date;
    
    //获得响应体
    UNNotificationRequest * request = notification.request;
    
    //获得响应体的标识符
//    NSString * identifier = request.identifier;
    
    // 唤起通知的对象
//    UNNotificationTrigger * trigger = request.trigger;
    
    //获得通知内容
    UNNotificationContent * content = request.content;
    
    //比如获得我想要的alert
    NSString * alertString = content.body;
    
    //可以弹出Alert提示一下
    [self performSelector:NSSelectorFromString(@"__showAlert:") withObject:alertString afterDelay:1];
    
    //比如这里可以进行界面的跳转等操作...
    
    //告知完成
    completionHandler();
}
```
<br>
#远程推送阶段预览

以上配置完毕后，使用PushMeBaby进行推送预览一下，以下是推送的内容。
具体内容的格式如下:[具体格式摘自简书博主linatan博文-iOS10-UserNotifications](http://www.jianshu.com/p/b74e52e866fc)
```
{
"aps":
    {
        "alert":
        {
            "title":"hello",
            "subtitle" : "Session 01",
            "body":"it is a beautiful day"
        },
        "category":"helloIdentifier",//比如我们想要使用自定义的UI,可以通过该值设置当前request对象的identifier
        "badge":1,
        "mutable-content":1,//如果想要启用Service的拓展，需要此数据，这个后面会有介绍
        "sound":"default",
        "image":"https://picjumbo.imgix.net/HNCK8461.jpg?q=40&w=200&sharp=30"
    }
}
```

在进行测试的过程中，楼主使用的远程推送如下:
```
//Demo中进行推送的内容如下:
{
    "aps":
    {
        "alert" : "This is My message Yue.",
        "badge" : "1",
        "mutable-content" : 1
    }
}

//pushMeBody中推送的字符串
self.payload = @"{\"aps\":{\"alert\":\"This is My message Yue.\",\"badge\":\"1\",\"mutable-content\":1}}";
```

后台接收的推送、响应3D Touch的推送以及点击推送进入App后的效果如下:
<div align=center><img src="http://img.blog.csdn.net/20160929153619342" height=400> </img>&nbsp<img src="http://img.blog.csdn.net/20160929153818798" height=400></img>&nbsp <img src="http://img.blog.csdn.net/20160929153631764" height=400></img></div>
<br>
#本地进行推送

##项目中推送的声明类

对于Demo中大部分的测试，楼主都是使用了本地推送，所以楼主将推送功能封装成了`RITLPushMessageManager`类，声明方法如下:
```
/// iOS10之前的本地推送
- (void)pushLocationNotificationbeforeiOS10;

//由于iOS10推送的可更新性，还新增了一个枚举，当然，本来是不需要的，但为了测试才有的这个枚举类型
typedef NS_ENUM(NSUInteger, RITLPushMessageType)
{
    RITLPushMessageTypeNew = 0,     /**<默认为推送新的推送通知*/
    RITLPushMessageTypeUpdate = 1,  /**<更新当前的推送通知*/
};


/// iOS10 之后的本地推送，并根据类型选择是新的推送还是更新
- (void)pushLicationNotification:(nullable NSArray <UNNotificationAttachment *> *)attachments
                        pushType:(RITLPushMessageType)type NS_AVAILABLE_IOS(10_0);
```

<br>
##UserNotifications以前本地推送

这个推送相信大家都是比较熟的了，使用iOS10建议废弃的`UILocalNotification`类，实现方法如下:
```
-(void)pushLocationNotificationbeforeiOS10
{
    UILocalNotification * localNotification = [[UILocalNotification alloc]init];
    
    //设置消息体
    localNotification.alertBody = @"RITL send a location notications (iOS9)";
    
#ifdef __IPHONE_8_2
    //设置详细内容,iOS8.2才存在
    localNotification.alertTitle = @"I am SubTitle";
#endif
    
    //设置弹出时的图
    localNotification.alertLaunchImage = @"Stitch.png";
    
#ifdef __IPHONE_8_0
    //拓展id
    localNotification.category = RITLRequestIdentifier;
#endif
    
    //触发声音
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //触发标志
    localNotification.applicationIconBadgeNumber = 1;
    
    //1秒之后触发
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    
    //注册通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
```

<br>
##UserNotifications下的本地推送
在新的框架下，所有的推送都是使用了`UNNotificationRequest`类，这里有一点需要注意:<font color=red> 媒体的url可以存储在UNNotificationAttachment类之中，但是必须是本地路径，如果是网络图，需要先从网络下载下来，存到本地，然后将本地的路径存储进行处理；如果UNNotificationAttachment对象初始化失败，会抛出异常，导致程序崩溃。比如Demo中就是通过选择相册的照片进行本地化，再赋值路径来进行的本地推送</font>实现方法如下:
```
-(void)pushLicationNotification:(NSArray <UNNotificationAttachment *> *)attachments pushType:(RITLPushMessageType)type
{
    NSString * subTitle = (type == RITLPushMessageTypeNew ? @"I am a new SubTitle" : @"I am a update SubTitle");
    
    //初始化信息对象
    UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc]init];
    
    //设置内容
    content.body = @"RITL send a location notications";
    
    //设置详细内容
    content.subtitle = subTitle;
    
    //设置图片名称
    content.launchImageName = @"Stitch.png";
    
    //设置拓展id
    content.categoryIdentifier = RITLRequestIdentifier;
    
    //设置推送声音
    content.sound = [UNNotificationSound defaultSound];
    
    //设置通知
    content.badge = @1;
    
    //设置附带信息
    content.userInfo = @{@"RITL":@"I am RITL.",@"network":@"https://www.baidu.com"};
    
    //媒体附带信息
    content.attachments = attachments;
    
#pragma mark - 延时发送
    UNTimeIntervalNotificationTrigger * trigger = [UNNotificationTrigger defaultTimeIntervalNotificationTrigger];                                                        
                                                           
    //初始化通知请求
    UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:RITLRequestIdentifier content:content trigger:trigger];
    
    //如果是更新，先移除
    if (type == RITLPushMessageTypeUpdate)
        [[UNUserNotificationCenter currentNotificationCenter]removeDeliveredNotificationsWithIdentifiers:@[RITLRequestIdentifier]];
    
    
    //获得推送控制中心
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        if(error != nil)//出错
        {
            NSLog(@"error = %@",error.localizedDescription);
        }
    }];
}
```
<br>
##UNNotificationTrigger 消息触发类

可能名字翻译的不是那么正确，但个人的理解，它就是负责触发条件的，比如Demo中的类别`UNNotificationTrigger+RITLConveniceInitialize`中，为Demo提供了三种默认的触发条件，如下:
```
///默认的延时推送触发时机
+(UNTimeIntervalNotificationTrigger *)defaultTimeIntervalNotificationTrigger
{
    return [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:false];
}
```
```
/// 默认的日历推送触发时机
+(UNCalendarNotificationTrigger *)defaultCalendarNotificationTrigger
{
    
    NSDateComponents * dateCompents = [NSDateComponents new];
    dateCompents.hour = 7;//表示每天的7点进行推送
    return [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateCompents repeats:true];
}
```
```
/// 默认的地域推送触发时机
+(UNLocationNotificationTrigger *)defaultLocationNotificationTrigger
{
    // 因为CLRegion类的初始化方法在iOS7提示废弃，改用它的子类CLCircularRegion
    //    CLRegion * region = [CLRegion alloc]initCircularRegionWithCenter:cooddinate2D(100,100) radius:200 identifier:locationTriggerIdentifier
    
    //经纬度分别都是100
    CLLocationCoordinate2D coordinate2D = cooddinate2D(100,100);

    //初始化范围类
    CLCircularRegion * region = [[CLCircularRegion alloc]initWithCenter:coordinate2D radius:200 identifier:locationTriggerIdentifier];

    return [UNLocationNotificationTrigger triggerWithRegion:region repeats:false];

}
```
<br>
#本地推送阶段预览

楼主选择使用在本地相册中选择一个图片来完成本地推送，大体思路如下:
```
//该过程通过类别UNNotificationAttachment+RITLConceniceInitialize实现
+(NSArray<UNNotificationAttachment *> *)defaultNotificationAttachmentsWithImage:(UIImage *)image
{
    if (image == nil) return nil;
    
    NSMutableArray <UNNotificationAttachment *> * attachments = [NSMutableArray arrayWithCapacity:1];
    
    //将image存到本地
    [RITLPushFilesManager saveImage:image key:imageTransformPathKey];
    
    NSError * error;
    
    UNNotificationAttachment * attachment = [UNNotificationAttachment attachmentWithIdentifier:attachmentIdentifier URL:[RITLPushFilesManager imageUrlPathWithKey:imageTransformPathKey] options:nil error:&error];
    
    NSAssert(error == nil, error.localizedDescription);
    
    [attachments addObject:attachment];
    
    return [attachments mutableCopy];
}
```

预览图如下:
<div align="center"><img  src="http://img.blog.csdn.net/20160929170607960" height=400></img> &nbsp<img src="http://img.blog.csdn.net/20160929170618713" height=400></img>&nbsp <img src="http://img.blog.csdn.net/20160929170629460" height=400></img></div>

<br>
#推送消息的策略

推送策略是什么呢，可以理解为推送的一个"类别"，当我们使用3D Touch得以响应推送信息之后，会出现类似的一排按钮，不过目前最大的限制为4个，并且最早出于iOS 8.0（那个时候没有3D Touch感应，怎么能唤出拓展呢? 如果能告知的小伙伴，也请告知一下楼主，十分感谢）

同样为了方便管理添加拓展，将添加拓展的方法封装成`RITLPushCategoryManager`类

##UserNotifications之前推送策略
```
// 为Demo添加默认的策略--before iOS10
+(UIUserNotificationCategory *)addDefaultCategorysBeforeiOS10
{
    //设置普通响应 -- 表示没有便利初始化方法很坑
    UIMutableUserNotificationAction * foregroundAction = [UIMutableUserNotificationAction new];
    //设置属性
    foregroundAction.identifier = foregroundActionIdentifier;
    foregroundAction.title = @"收到了";
    foregroundAction.activationMode = UIUserNotificationActivationModeForeground;
    
    
    //设置文本响应
    UIMutableUserNotificationAction * destructiveTextAction = [UIMutableUserNotificationAction new];
    //设置属性
    destructiveTextAction.identifier = destructiveTextActionIdentifier;
    destructiveTextAction.title = @"我想说两句";
    destructiveTextAction.activationMode = UIUserNotificationActivationModeForeground;
    destructiveTextAction.behavior = UIUserNotificationActionBehaviorTextInput;
    destructiveTextAction.authenticationRequired = false;
    destructiveTextAction.destructive = true;
    
    //初始化Category
    UIMutableUserNotificationCategory * category = [UIMutableUserNotificationCategory new];
    //设置属性
    category.identifier = RITLRequestIdentifier;
    [category setActions:@[foregroundAction,destructiveTextAction] forContext:UIUserNotificationActionContextDefault];
    
    //返回
    return [category copy];
}

//并在外部使用注册推送的时候添加即可,代码有点长，Demo中有演示
/*
[[UIApplication sharedApplication] registerUserNotificationSettings:categories：中的第二个参数，以NSSet的形式传入即可
*/
```

##UserNotifications下的推送策略

UserNotifications框架为我们提供了很多的便利初始化方法，从代码也可以看出它的简洁性，由于是单行，所以会显得比较长 (相信我，在这里换行格式也是很难看的，所以索性用了一行 0.0)
```
+(void)addDefaultCategorys
{
    // 设置响应
    UNNotificationAction * foregroundAction = [UNNotificationAction actionWithIdentifier:foregroundActionIdentifier title:@"收到了" options:UNNotificationActionOptionForeground];
    
    // 设置文本响应
    UNTextInputNotificationAction * destructiveTextAction = [UNTextInputNotificationAction actionWithIdentifier:destructiveTextActionIdentifier title:@"我想说两句" options:UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground textInputButtonTitle:@"发送" textInputPlaceholder:@"想说什么?"];
    
    // 初始化策略对象,这里的categoryWithIdentifier一定要与需要使用Category的UNNotificationRequest的identifier匹配(相同)才可触发
    UNNotificationCategory * category = [UNNotificationCategory categoryWithIdentifier:RITLRequestIdentifier actions:@[foregroundAction,destructiveTextAction] intentIdentifiers:@[foregroundActionIdentifier,destructiveTextActionIdentifier] options:UNNotificationCategoryOptionCustomDismissAction];
    
    //直接通过UNUserNotificationCenter设置策略即可
    [[UNUserNotificationCenter currentNotificationCenter]setNotificationCategories:[NSSet setWithObjects:category, nil]];
    
}
```
##响应策略的方式
如何响应我们添加的策略呢，这里就只介绍UserNotifications下的响应方法，找到负责响应最新推送协议方法的类别RITLOriginPushAppDelegate+RITLUserNotifications:

在`- (void)userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:`方法体最前面进行一下策略判定即可，如下:
```
if ([response.actionIdentifier isEqualToString:foregroundActionIdentifier])
{
    //可以弹出Alert提示一下
    [self performSelector:NSSelectorFromString(@"__showAlert:") withObject:@"我是第一个策略动作,收到了" afterDelay:0];
    
    completionHandler();return;
}

else if([response.actionIdentifier isEqualToString:destructiveTextActionIdentifier])
{
    [self performSelector:NSSelectorFromString(@"__showAlert:") withObject:[NSString stringWithFormat:@"我是第二个文本动作，我输入的文字是:%@",((UNTextInputNotificationResponse *)response).userText] afterDelay:0];
    
    completionHandler();return;
}
```

##推送策略阶段预览
下面是通过Touch唤起推送策略、响应text策略以及响应策略的预览图
<div align="center"><img src="http://img.blog.csdn.net/20160929172741804" height=400></img> &nbsp<img src="http://img.blog.csdn.net/20160929172751132" height=400></img> &nbsp<img src="http://img.blog.csdn.net/20160929172801663" height=400></img></div>

<br>
#推送拓展插件-NotificationContentExtension

##创建方式

与Widget插件化开发的创建步骤是一样的呢，File->New->Target->NotificationContentExtension

<img src="http://img.blog.csdn.net/20160930101427680" width=500></img>

创建成功之后，默认的控制器名称为NotificationViewController，Demo中仅仅改了一下名字，文件夹分布如下:

<img src="http://img.blog.csdn.net/20160930101718044" width=400></img>

如果牵扯到UI的绘制的方法，数据与代码的共享的方法，作为插件化开发其实是一致的，可回顾一下博主之前的博文[iOS开发------Widget(Today Extension)插件化开发](http://blog.csdn.net/runintolove/article/details/52595770#t2)感谢。

<font color=red>这里需要注意一下，如果我们创建了拓展，但是本地推送的UI如果还是默认的UI形式，这个时候就需要看一下Info.plist文件下  NSExtension->NSExtensionAttributes->UNNotificationExtensionCategory  （默认是一个String类型），里面需要与UNNotificationRequest对象的identifier相匹配才可触发；如果支持多个通知，可以将UNNotificationExtensionCategory更改为数组类型。</font>下面是一个栗子0.0

下面是Demo中进行本地推送中初始化UNNotificationRequest对象的具体代码形式:
```
//作为一个全局的固定字符串
NSString * const RITLRequestIdentifier = @"com.yue.originPush.myNotificationCategory";

//初始化通知请求
UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:RITLRequestIdentifier content:content trigger:trigger];
```

同时为了保证能够触发自定义的推送UI，Demo中的plist文件设置如下:

<img src="http://img.blog.csdn.net/20160930102548784" width=400></img>

在Demo中，楼主依旧使用了storyboard进行UI布局，也只因为是研究框架，所以布局是非常的简单，如下:

<img src="http://img.blog.csdn.net/20160930103223376" width=400></img>

##UNNotificationContentExtension协议

这个协议也是比较简单的，只有两个协议方法，有一个必须实现的方法，也有一个可选的。
```
// 收到推送消息后进行的回调，必须实现的方法
- (void)didReceiveNotification:(UNNotification *)notification
{
    //获得内容对象
    UNNotificationContent * content = notification.request.content;
    
    //获得需要展示的文本
    NSString * customTitle = content.body;
    
    //需要展示的图片
    UIImage * image = [UIImage imageNamed:content.launchImageName];
    
    //设置
    self.customlabel.text = customTitle;
    
    //这是拓展里自定义的图片
    self.customimageView.image = image;
    
    //这是通知里带的照片
    self.attachmentImageView.image = nil;//直接使用attachment对象的路径进行加载即可
    
    //如果是远程推送的网络图没有加载怎么办，这里不用担心
    //下面的NotificationServiceExtension就是解决这个问题的
}
```

下面这个协议方法是可选的。
它的作用就是，当我们使用自定义的UI进行通知显示的时候，通过点击或者响应策略Action的时候，会优先执行该协议方法，并通过它的回调来决定下一步的操作。
```
//回调类型的个人理解如下:
typedef NS_ENUM(NSUInteger, UNNotificationContentExtensionResponseOption)
{
    UNNotificationContentExtensionResponseOptionDoNotDismiss, //默认表示不消失
    UNNotificationContentExtensionResponseOptionDismiss,//消失
    UNNotificationContentExtensionResponseOptionDismissAndForwardAction,//消失并让App对它进行处理，这个时候才会走原应用的回调
};

```

```
// 展开后的推送消息得到点击响应
- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption option))completion
{
    //进行回调，这里是使其消失并回到主App进行处理，处理完毕之后会走UNUserNotificationCenter的协议方法
    completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
}
```
<br>
#NotificationContentExtension阶段预览

下面是使用自定义的通知UI、使用策略输入文本以及最后响应文本的操作

<div align="center"><img src="http://img.blog.csdn.net/20160930104326480" height=400></img> &nbsp<img src="http://img.blog.csdn.net/20160930104334923" height=400></img> &nbsp<img src="http://img.blog.csdn.net/20160930104348407" height=400></img></div>

<br>
#推送拓展插件-NotificationServiceExtension

如果眼睛比较厉害的小伙伴估计上面的截图也看到了，在NotificationContentExtension旁边，如下图:

<img src="http://img.blog.csdn.net/20160930104753717" width=500></img>

这个插件的作用是什么呢，当然这个插件主要是用于<font color=red>远程推送</font>的数据处理，它能够给我们最长30秒的时间让我们对远程推送的内容进行修改，或者对推送内容中的图片、视频、音频链接进行下载的过程。

当然大部分的代码系统已经帮我们写好了，这里之贴上Demo中的一个小实现，作用就是在收到远程推送的时候，修改推送的内容，如下:
```
//大约会给30秒的时间限制
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    
    //获取request以及block对象
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    
    //对内容可以进行修改
    self.bestAttemptContent.body = @"我是在Service里面修改后的title";
    
    //如果如果含有图片，视频音频的url，可以利用这里进行下载coding...
    
    //然后初始化UNNotificationAttachment对象，赋值数组即可
    
    //回调处理完毕的content内容
    self.contentHandler(self.bestAttemptContent);
}
```

下面的协议方法虽然能大体翻译出来，但却不知道到底有什么用，如果有知道的小伙伴，也请告知一下，十分感谢
```
//提供最后一个机会，当该拓展将被系统杀死的时候执行的方法
- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    
    //就比如上面英文介绍所说的：可以用这个机会来表达一下你最想在content中表达的，不然的话最初推送的payload将被用到
    self.contentHandler(self.bestAttemptContent);
}
```

#NotificationServiceExtension阶段预览

使用pushMeBody进行一次远程推送，Touch响应以及点击推送该内容结果如下:

<div align=center><img src="http://img.blog.csdn.net/20160930105910580" height=400></img> &nbsp<img src="http://img.blog.csdn.net/20160930105920690" height=400></img> &nbsp<img src="http://img.blog.csdn.net/20160930105929783" height=400></img></div>

出了文中提到的博文，最后还要感谢下面博文对该博文的帮助:
[iOS 10 新特性之通知推送--干货一篇](http://www.jianshu.com/p/a5e2d7c63e79)
[活久见的重构 - iOS 10 UserNotifications 框架解析](https://onevcat.com/2016/08/notification/)

最后祝大家工作开心，明天就要为祖国庆生了，也祝大家节日快乐。
