package cn.waps.extend;

import java.util.List;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.GradientDrawable.Orientation;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.Window;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import cn.waps.AdInfo;
import cn.waps.AppConnect;
import cn.waps.SDKUtils;

public class AppWall extends Activity {

	private final Handler mHandler = new Handler();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		this.requestWindowFeature(Window.FEATURE_NO_TITLE);
		super.onCreate(savedInstanceState);
		// 加载自定义广告列表布局
		this.setContentView(getContentView(this));
	}
	
	private View getContentView(final Context context){
		// 对手机进行屏幕判断
		int displaySize = SDKUtils.getDisplaySize(context);
		// 整体布局
		LinearLayout layout = new LinearLayout(context);
		layout.setBackgroundColor(Color.WHITE);
		try {
			layout.setOrientation(LinearLayout.VERTICAL);
			// 标题布局
			RelativeLayout title_layout = new RelativeLayout(context);
			title_layout.setGravity(Gravity.CENTER_VERTICAL);
			title_layout.setPadding(0, 2, 0, 0);
			if(displaySize == 320){
				title_layout.setLayoutParams(new LinearLayout.LayoutParams(LayoutParams.FILL_PARENT, 48));
			}else if(displaySize == 240){
				title_layout.setLayoutParams(new LinearLayout.LayoutParams(LayoutParams.FILL_PARENT, 32));
			}else if(displaySize == 720){
				title_layout.setLayoutParams(new LinearLayout.LayoutParams(LayoutParams.FILL_PARENT, 100));
			}else if(displaySize == 1080){
				title_layout.setLayoutParams(new LinearLayout.LayoutParams(LayoutParams.FILL_PARENT, 150));
			}else{
				title_layout.setLayoutParams(new LinearLayout.LayoutParams(LayoutParams.FILL_PARENT, 75));
			}
			GradientDrawable title_gradient = new GradientDrawable(Orientation.TOP_BOTTOM, 
				new int[] {Color.parseColor("#eeeeee"), Color.parseColor("#bbbbbb")}); 
			title_layout.setBackgroundDrawable(title_gradient);
			
			Button button = new Button(context);
			button.setGravity(Gravity.CENTER);
			button.setText("返 回");
			button.setOnClickListener(new OnClickListener(){
				@Override
				public void onClick(View v) {
					((Activity)context).finish();
				}
			});
			TextView textView = new TextView(context);
			textView.setText("热门应用推荐");
			textView.setTextSize(16);
			textView.setTextColor(Color.BLACK);
			textView.setGravity(Gravity.CENTER);
			
			RelativeLayout.LayoutParams params1 = new RelativeLayout.LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT);
			params1.addRule(RelativeLayout.CENTER_IN_PARENT);
			
			RelativeLayout.LayoutParams params2 = null;
			if(displaySize == 320){
				params2 = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, 36);
			}else if(displaySize == 240){
				params2 = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, 28);
			}else if(displaySize == 720){
				params2 = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, 80);
			}else if(displaySize == 1080){
				params2 = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, 120);
			}else{
				params2 = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, 60);
			}
			params2.addRule(RelativeLayout.CENTER_VERTICAL);
			params2.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
			
			title_layout.addView(textView, params1);
			title_layout.addView(button, params2);
			
			ListView listView = new ListView(context);
			listView.setBackgroundColor(Color.WHITE);
			listView.setCacheColorHint(0);
			//设置ListView每个Item间的间隔线的颜色渐变
			GradientDrawable divider_gradient = new GradientDrawable(Orientation.TOP_BOTTOM, 
				new int[] {Color.parseColor("#cccccc"), Color.parseColor("#ffffff"), Color.parseColor("#cccccc")}); 
			listView.setDivider(divider_gradient);
			
			int line_size = 4;
			if(displaySize == 240){
				line_size = 2;
			}
			listView.setDividerHeight(line_size);
			// 异步加载自定义广告数据
			new GetDiyAdTask(context, listView).execute();
			
			layout.addView(title_layout);
			layout.addView(listView);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return layout;
	}
	
	private class MyAdapter extends BaseAdapter{
    	Context context;
    	List<AdInfo> list;
    	public MyAdapter(Context context, List<AdInfo> list){
    		this.context = context;
    		this.list = list;
    	}
		@Override
		public int getCount() {
			return list.size();
		}
		@Override
		public Object getItem(int position) {
			return list.get(position);
		}
		@Override
		public long getItemId(int position) {
			return position;
		}
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			final AdInfo adInfo = list.get(position);
			
			View adatperView = null;
			
			try {
				adatperView = AppItemView.getInstance().getAdapterView(context, adInfo, 0, 0);
					
				convertView = adatperView;
				convertView.setTag(adatperView);
			} catch (Exception e) {
				e.printStackTrace();
			}
			
            return adatperView;
		}
    }
	
	private class GetDiyAdTask extends AsyncTask<Void, Void, Boolean>{
		
		Context context;
		ListView listView;
		List<AdInfo> list;
		
		GetDiyAdTask(Context context, ListView listView){
			this.context = context;
			this.listView = listView;
		}
		
		@SuppressWarnings("unchecked")
		@Override
		protected Boolean doInBackground(Void... params) {
			try {
				int i = 0;
				while(true){
					if(i > 10){
						i = 0;
						break;
					}
					if(!new SDKUtils(context).isConnect()){
						mHandler.post(new Runnable(){
							
							@Override
							public void run() {
								Toast.makeText(context, "数据获取失败,请检查网络重新加载", Toast.LENGTH_LONG).show();
								((Activity)context).finish();
							}
						});	
						
						break;
					}
					list = AppConnect.getInstance(context).getAdInfoList();
					if(list != null && !list.isEmpty()){
						
						mHandler.post(new Runnable(){
							
							@Override
							public void run() {
								listView.setAdapter(new MyAdapter(context, list));
							}
						});	
						
						break;
					}
					
					i++ ;
					try {
						Thread.sleep(1000);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			return null;
		}
	}

}
