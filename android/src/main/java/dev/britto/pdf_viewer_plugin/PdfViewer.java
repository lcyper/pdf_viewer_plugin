package dev.britto.pdf_viewer_plugin;

import com.github.barteksc.pdfviewer.PDFView;
import com.github.barteksc.pdfviewer.listener.OnPageChangeListener;

import android.content.Context;
import android.os.Build;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.io.File;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.platform.PlatformView;
import android.graphics.Color;

/// Disable the PdfView recycle when onDetachedFromWindow is called, fixing the
/// flutter hot reload.
class CustomPDFView extends PDFView {
    boolean enableRecycle = true;

    public CustomPDFView(Context context, AttributeSet set) {
        super(context, set);
    }

    @Override
    protected void onDetachedFromWindow() {
        Log.i("PdfViewer", "onDetachedFromWindow");
        enableRecycle = false;
        super.onDetachedFromWindow();
        enableRecycle = true;
    }

    @Override
    public void recycle() {
        if (enableRecycle) {
            super.recycle();
        }
    }
}

public class PdfViewer implements PlatformView, MethodCallHandler {
    final MethodChannel methodChannel;
    private PDFView pdfView;
    private String filePath;
    private Boolean nightMode;
    private int initialPage;
    private Boolean swipeHorizontal = false;
    private int spacing;
    private String bgColorString = "#000000";


    PdfViewer(final Context context,
              MethodChannel methodChannel,
              Map<String, Object> params,
              View containerView) {
//        Log.i("PdfViewer", "init");

        this.methodChannel = methodChannel;
        this.methodChannel.setMethodCallHandler(this);

        //pdfView.setBackgroundColor(Color.parseColor(bgColorString));
        //pdfView.setBackgroundColor(Color.YELLOW);
        pdfView = new CustomPDFView(context, null);

        if (!params.containsKey("filePath")) {
            return;
        }
        filePath = (String)params.get("filePath");
        // -------------------------------------- /
        //containerView.setBackgroundColor(-256);
        if (params.containsKey("nightMode")) {
            nightMode = (Boolean)params.get("nightMode");
        }
        if (params.containsKey("initialPage")) {
            initialPage = (Integer) params.get("initialPage")-1;
            Log.i("PdfViewer", "initialPage is "+ initialPage);
        }
        if (params.containsKey("swipeHorizontal")) {
            swipeHorizontal = (Boolean) params.get("swipeHorizontal");
        }
        if (params.containsKey("spacing")) {
            spacing = (int) params.get("spacing");

        }
        if (params.containsKey("maxZoom")) {
            pdfView.setMaxZoom((float)params.get("maxZoom"));
        }
        if (params.containsKey("minZoom")) {
            pdfView.setMinZoom((float)params.get("minZoom"));
        }
        if (params.containsKey("midZoom")) {
            pdfView.setMidZoom((float)params.get("midZoom"));
        }

        // -------------------------------------- //


        loadPdfView();
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPdfViewer")) {
            result.success(null);
        } else {
            result.notImplemented();
        }
    }

    private void loadPdfView() {
        pdfView.fromFile(new File(filePath))
                .enableSwipe(true) // allows to block changing pages using swipe
                .swipeHorizontal(swipeHorizontal)
                .enableDoubletap(true)
                .defaultPage(initialPage)
                .nightMode(nightMode)
                .spacing(spacing)
                .onPageChange(new OnPageChangeListener() {
                    @Override
                    public void onPageChanged(int page, int pageCount) {
                        methodChannel.setMethodCallHandler(new MethodCallHandler() {
                            @Override
                            public void onMethodCall(@NonNull MethodCall methodCall, @NonNull Result result) {
                                
                            }
                        });
                    }
                })
                //.onPageError()
                //.onRender()
                .enableAntialiasing(true)
                .enableAnnotationRendering(true)
                .load();
    }

    @Override
    public View getView() {
        return pdfView;
    }

     @Override
    public void onFlutterViewAttached(@NonNull View flutterView) {
//         Log.i("PdfViewer", "onFlutterViewAttached");
    }

    @Override
    public void onFlutterViewDetached() {
//        Log.i("PdfViewer", "onFlutterViewDetached");
    }


    @Override
    public void dispose() {
//        Log.i("PdfViewer", "dispose");
        methodChannel.setMethodCallHandler(null);
    }
}
