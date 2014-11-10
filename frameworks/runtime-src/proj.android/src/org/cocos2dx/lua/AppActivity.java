/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2011      Zynga Inc.
Copyright (c) 2013-2014 Chukong Technologies Inc.
 
http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package org.cocos2dx.lua;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Enumeration;
import java.util.ArrayList;

import org.cocos2dx.lib.Cocos2dxActivity;

import cn.waps.AdInfo;
import cn.waps.AppConnect;
import cn.waps.UpdatePointsNotifier;
import cn.waps.extend.AppDetail;
import cn.waps.extend.QuitPopAd;

import com.tencent.mm.sdk.modelmsg.SendMessageToWX;
import com.tencent.mm.sdk.modelmsg.WXMediaMessage;
import com.tencent.mm.sdk.modelmsg.WXTextObject;
import com.tencent.mm.sdk.modelmsg.WXWebpageObject;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.zaojiahua.DontCrash.R;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.ActivityInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.Settings;
import android.text.format.Formatter;
import android.util.Log;
import android.view.Gravity;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.Toast;

// The name of .so is specified in AndroidMenifest.xml. NativityActivity will load it automatically for you.
// You can use "System.loadLibrary()" to load other .so files.

public class AppActivity extends Cocos2dxActivity implements UpdatePointsNotifier{

	//微信SDK
	private static final String APP_ID = "wx42ca6be8e52eebfb";
	private static IWXAPI api;
	private static AppActivity instance;
	
	//万普广告成员变量
	private static Handler handler;
	private static Context mContext;
	private String app_id = "be1732d3a68f06c7631a59489728559f";

	
	static String hostIPAdress="0.0.0.0";
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
		//注册到微信
		regToWX();
		
		//初始化广告
		mContext = this;
		handler = new AdHandler();
		initAds();
		
		if(nativeIsLandScape()) {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
		} else {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT);
		}
		
		//2.Set the format of window
		
		// Check the wifi is opened when the native is debug.
		if(nativeIsDebug())
		{
			getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
			if(!isNetworkConnected())
			{
				AlertDialog.Builder builder=new AlertDialog.Builder(this);
				builder.setTitle("Warning");
				builder.setMessage("Open Wifi for debuging...");
				builder.setPositiveButton("OK",new DialogInterface.OnClickListener() {
					
					@Override
					public void onClick(DialogInterface dialog, int which) {
						startActivity(new Intent(Settings.ACTION_WIFI_SETTINGS));
						finish();
						System.exit(0);
					}
				});
				builder.setCancelable(false);
				builder.show();
			}
		}
		hostIPAdress = getHostIpAddress();
	}
	
	//初始化广告
	public void initAds(){
		//初始化广告
		AppConnect.getInstance(app_id,"QQ",this);
		// 预加载插屏广告内容(仅在使用到插屏广告的情况,才需要添加)
		AppConnect.getInstance(this).initPopAd(this);
		// 预加载自定义广告内容(仅在使用了自定义广告、抽屉广告或迷你广告的情况,才需要添加)
		AppConnect.getInstance(this).initAdInfo();
	}
	//关闭广告
	protected void onStop(){
		//关闭广告
		AppConnect.getInstance(this).close();
	}
	
	// 向handler发送要展示Banner的消息
	public static void showAdStatic(int adTag) {
		Message msg = handler.obtainMessage();
		// 私有静态的整型变量,开发者请自行定义值
		msg.what = adTag;
		handler.sendMessage(msg);
	}
		
	class AdHandler extends Handler{
		public void handleMessage(Message msg) {
			switch (msg.what){
			case 0:
				// 显示推荐列表(综合)
				AppConnect.getInstance(mContext).showOffers(mContext);
				break;
			case 1:
				// 显示插屏广告
				// 判断插屏广告是否已初始化完成,用于确定是否能成功调用插屏广告
				boolean hasPopAd = AppConnect.getInstance(mContext).hasPopAd(mContext);
				if (hasPopAd) {
					AppConnect.getInstance(mContext).showPopAd(mContext);
				}
				break;
			case 2:
				// 显示推荐列表(软件)
				AppConnect.getInstance(mContext).showAppOffers(mContext);
				break;
			case 3:
				// 显示推荐列表(游戏)
				AppConnect.getInstance(mContext).showGameOffers(mContext);
				break;
			case 4:
				// 获取全部自定义广告数据
				break;
			case 5:
				// 获取一条自定义广告数据
				AdInfo adInfo = AppConnect.getInstance(mContext).getAdInfo();
				AppDetail.getInstanct().showAdDetail(mContext, adInfo); 
				break;
			case 6:
				// 消费虚拟货币.
				AppConnect.getInstance(mContext).spendPoints(10,AppActivity.this);
				break;
			case 7:
				// 奖励虚拟货币
				AppConnect.getInstance(mContext).awardPoints(10,AppActivity.this);
				break;
			case 8:
				// 显示自家应用列表
				AppConnect.getInstance(mContext).showMore(mContext);
				break;
			case 9:
				// 根据指定的应用app_id展示其详情
				AppConnect.getInstance(mContext).showMore(mContext,app_id);
				break;
			case 10:
				// 调用功能广告接口(使用浏览器接口)
				String uriStr = "http://www.baidu.com"; AppConnect.getInstance(mContext).showBrowser(mContext,uriStr);
				break;
			case 11:
				// 用户反馈
				AppConnect.getInstance(mContext).showFeedback(mContext);
				break;
			case 12:
				// 退屏广告
				QuitPopAd.getInstance().show(mContext);
				break;
			case 13:
				// banner
				AppConnect.getInstance(mContext).showBannerAd(mContext,getBannerAd());
				break;
			case 14:
				// 迷你广告
				AppConnect.getInstance(mContext).showMiniAd(mContext,getMiniAd(), 10);
				break;
			}
		}

		//添加互动广告
		private LinearLayout getBannerAd(){
			// 互动广告
			LinearLayout adBannerLayout = new LinearLayout(mContext);
			adBannerLayout.setOrientation(LinearLayout.VERTICAL);
			FrameLayout.LayoutParams lp_banner = new FrameLayout.LayoutParams(
			FrameLayout.LayoutParams.WRAP_CONTENT,
			FrameLayout.LayoutParams.WRAP_CONTENT);
			// 设置adBannerLayout的悬浮位置,具体的位置开发者根据需要设置
			lp_banner.gravity = Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL;
			AppActivity.this.addContentView(adBannerLayout, lp_banner);

			LinearLayout bannerLayout = new LinearLayout(mContext);
			adBannerLayout.addView(bannerLayout);

			return bannerLayout;
		}

		//添加迷你广告
		private LinearLayout getMiniAd(){
			LinearLayout adMiniLayout = new LinearLayout(mContext);
			adMiniLayout.setOrientation(LinearLayout.VERTICAL);
			FrameLayout.LayoutParams lp_mini = new FrameLayout.LayoutParams(
			FrameLayout.LayoutParams.WRAP_CONTENT,
			FrameLayout.LayoutParams.WRAP_CONTENT);
			// 设置adMiniLayout的悬浮位置,具体的位置开发者根据需要设置
			lp_mini.gravity = Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL;
			AppActivity.this.addContentView(adMiniLayout, lp_mini);
			LinearLayout miniLayout = new LinearLayout(mContext);
			adMiniLayout.addView(miniLayout);

			return miniLayout;
		}
	}
	
	//初始化微信
	private void regToWX(){
	    api = WXAPIFactory.createWXAPI(this, APP_ID, true);
	    api.registerApp(APP_ID);
	}
	
	//留下给c++层调用的接口
	public static void sendMsgToFriend(){
	    if(api.openWXApp())
	    {
	    		//初始化一个对象WebpageObject
	        WXTextObject textObject = new WXTextObject();
	        textObject.text = "小塔博客用lua写的小游戏别撞车，博客地址http://www.zaojiahua.com/tag/3-0%E9%A3%9E%E6%9C%BA%E5%A4%A7%E6%88%98！";

	        //媒体对象中
	        WXMediaMessage msg = new WXMediaMessage(textObject);
	        msg.title = "别撞车";
	        msg.description = "分享给你的好友，让更多的人来玩！";

	        //建立请求对象
	        SendMessageToWX.Req req = new SendMessageToWX.Req();
	        //transaction是用来表示一个请求的唯一标示符
	        req.transaction = buildTransaction("textObject");
	        req.message = msg;
	        req.scene = SendMessageToWX.Req.WXSceneSession;

	        //使用通信类发送
	        api.sendReq(req);
	    }
	    else
	    {
	         Toast.makeText(instance, "启动微信失败！", Toast.LENGTH_SHORT).show();
	    }
	}

	public static void sendMsgToTimeLine(){
	    if(api.openWXApp())
	    {
	        if(api.getWXAppSupportAPI() >= 0x21020001)
	        {
	            WXWebpageObject webpage = new WXWebpageObject();
	            webpage.webpageUrl = "http://m.baidu.com/app?action==content&docid=6561264&f=s1001";

	            WXMediaMessage msg = new WXMediaMessage(webpage);
	            msg.title = "奔跑吧新娘";
	            msg.description = "分享到我的朋友圈，让更多的人来玩！";

	            Bitmap thumb = BitmapFactory.decodeResource(instance.getResources(),R.drawable.icon);
	            msg.thumbData = Util.bmpToByteArray(thumb, true);

	            SendMessageToWX.Req req = new SendMessageToWX.Req();
	            req.transaction = buildTransaction("webpage");
	            req.message = msg;
	            req.scene = SendMessageToWX.Req.WXSceneTimeline;
	            api.sendReq(req);
	        }
	        else{
	            Toast.makeText(instance, "微信版本过低", Toast.LENGTH_SHORT).show();
	        }
	    }
	    else
	    {
	         Toast.makeText(instance, "启动微信失败", Toast.LENGTH_SHORT).show();
	    }
	}
	private static String buildTransaction(final String type) {
	    return (type == null) ? String.valueOf(System.currentTimeMillis()) : type + System.currentTimeMillis();
	}
	
	

	private boolean isNetworkConnected() {
	        ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);  
	        if (cm != null) {  
	            NetworkInfo networkInfo = cm.getActiveNetworkInfo();  
			ArrayList networkTypes = new ArrayList();
			networkTypes.add(ConnectivityManager.TYPE_WIFI);
			try {
				networkTypes.add(ConnectivityManager.class.getDeclaredField("TYPE_ETHERNET").getInt(null));
			} catch (NoSuchFieldException nsfe) {
			}
			catch (IllegalAccessException iae) {
				throw new RuntimeException(iae);
			}
			if (networkInfo != null && networkTypes.contains(networkInfo.getType())) {
	                return true;  
	            }  
	        }  
	        return false;  
	    } 
	 
	public String getHostIpAddress() {
		WifiManager wifiMgr = (WifiManager) getSystemService(WIFI_SERVICE);
		WifiInfo wifiInfo = wifiMgr.getConnectionInfo();
		int ip = wifiInfo.getIpAddress();
		return ((ip & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF));
	}
	
	public static String getLocalIpAddress() {
		return hostIPAdress;
	}
	
	public static String getSDCardPath() {
		if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
			String strSDCardPathString = Environment.getExternalStorageDirectory().getPath();
           return  strSDCardPathString;
		}
		return null;
	}
	
	private static native boolean nativeIsLandScape();
	private static native boolean nativeIsDebug();

	@Override
	public void getUpdatePoints(String arg0, int arg1) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void getUpdatePointsFailed(String arg0) {
		// TODO Auto-generated method stub
		
	}
	
}
