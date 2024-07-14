package com.example.fiat_match

import android.app.Activity
import android.content.Intent
import android.widget.Toast
import androidx.annotation.NonNull
import com.unikrew.faceoff.liveness.*
import com.unikrew.faceoff.liveness.FaceoffLivenessInitializationActivity.FACEOFF_LIVENESS_CONFIG
import com.unikrew.faceoff.liveness.FaceoffLivenessInitializationActivity.LIVENESS_RESPONSE_CODE
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.fiatmatch.android/liveness"
    private var methodChannelResult: MethodChannel.Result? = null
    private val LIVENESS_CHECK_REQUEST = 111

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "launchSDK") {
                methodChannelResult = result
                launchSDK()
            }
        }
    }

    private fun launchSDK() {
        try {
            val config = LivenessConfig.Builder()
                    .setChallengeMoveYourFaceToLeft()
                    .setChallengeMoveYourFaceToRight()
                    .setChallengeNodYourHead()
                    .setMaxChallenges(1) //This defines the max number of challenges to show randomly from the defined challenges.
                    .build()
            val intent = Intent(this, FaceoffLivenessInitializationActivity::class.java)
            intent.putExtra(FaceoffLivenessInitializationActivity.FACEOFF_LIVENESS_CONFIG, config)
            startActivityForResult(intent, LIVENESS_CHECK_REQUEST)
        } catch (ex: LivenessConfigException) {
            Toast.makeText(this, ex.message, Toast.LENGTH_SHORT).show()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == LIVENESS_CHECK_REQUEST) {
            if (data != null) {
                val responseCode = data.getIntExtra(FaceoffLivenessInitializationActivity.LIVENESS_RESPONSE_CODE, -1)
                if (responseCode > 0) {
                    val livenessResponse = LivenessResponseIPC.getInstance().getLivenessResponse(responseCode)
                    val result: String = livenessResponse.response.responseCode.toString() + "|||" + livenessResponse.base64EncodedFullBitmap
                    methodChannelResult?.success(result);
                } else {
                    Toast.makeText(this, "Failed to receive the liveness response", Toast.LENGTH_SHORT).show()
                    methodChannelResult?.success("");
                }
            }
        }
    }
}
