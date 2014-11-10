package cn.waps.extend;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.SlidingDrawer;

public class SlideWallDrawer extends SlidingDrawer {

    private int mHandleMarginLeft = 0;

    public int getmHandleMarginLeft() {
            return mHandleMarginLeft;
    }

    /**
     * 设置handle左边边距
     * @param mHandleMarginLeft
     */
    public void setmHandleMarginLeft(int mHandleMarginLeft) {
            this.mHandleMarginLeft = mHandleMarginLeft;
    }

    public SlideWallDrawer(Context context, AttributeSet attrs) {
            super(context, attrs);
    }

    @Override
    protected void onLayout(boolean changed, int l, int t, int r, int b) {
            super.onLayout(changed, l, t, r, b);
            final int height = b - t;

            final View handle = this.getHandle();

            int childWidth = handle.getMeasuredWidth();
            int childHeight = handle.getMeasuredHeight();

            int childLeft;
            int childTop;

            final View content = this.getContent();

            childLeft = l + mHandleMarginLeft;
            childTop = this.isOpened() ? this.getPaddingTop() : height
                            - childHeight + this.getPaddingBottom();

            content.layout(0, this.getPaddingTop() + childHeight,
                            content.getMeasuredWidth(), this.getPaddingTop() + childHeight
                                            + content.getMeasuredHeight());

            handle.layout(childLeft, childTop, childLeft + childWidth, childTop
                            + childHeight);
    }

}
