package com.lumbermill.b_eater

import android.content.Intent
import android.graphics.drawable.AnimationDrawable
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.widget.ImageView
import android.widget.Toast
import kotlin.random.Random
import android.media.MediaPlayer
import androidx.appcompat.app.AlertDialog
import kotlinx.android.synthetic.main.activity_game.*
import android.R.id.edit
import android.content.SharedPreferences
import android.widget.Toast.LENGTH_SHORT
import android.widget.Toast.makeText


class GameActivity : AppCompatActivity() {
    private lateinit var sonAnimation: AnimationDrawable
    private lateinit var fatherAnimation: AnimationDrawable
    var randomValues: Long = 0
    var cMediaPlayer: MediaPlayer? = null
    var bMediaPlayer: MediaPlayer? = null
    var score = 0
    var flag = 0
    var pause = 0


    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_game)

        scoreView.setText("Score: " + score.toString())

        bMediaPlayer = MediaPlayer.create(this, R.raw.pixel_island)
        bMediaPlayer?.start()

        val sonImage = findViewById<ImageView>(R.id.sonid).apply {
            setBackgroundResource(R.drawable.son)
            sonAnimation = background as AnimationDrawable
        }


        val fatherImage = findViewById<ImageView>(R.id.fatherid).apply {
            setBackgroundResource(R.drawable.father)
            fatherAnimation = background as AnimationDrawable

        }

        startPlay.setOnClickListener {
            if(sonAnimation.isRunning == false){
                sonAnimation.start()
                pause = 1
                startPlay.setText("Stop")
            }
            else{
                sonAnimation.stop()
                pause = 0
                startPlay.setText("Start")
            }


        }


        val h = Handler()
        h.postDelayed(object : Runnable {
            override fun run() {
                if (sonAnimation.current == sonAnimation.getFrame(2) && fatherAnimation.current == fatherAnimation.getFrame(
                        2
                    )
                ) {
                    bMediaPlayer?.stop()
                    caughtMusic()
                    sonAnimation.stop()
                    fatherAnimation.stop()
                    flag = 1
                    highScores()
                    showDialog()

                }

                if (sonAnimation.current == sonAnimation.getFrame(1) && flag == 0 && pause == 1) {
                    score += 1
                    scoreView.setText("Score: " + score.toString())
                }
                if (flag == 0) {
                    if (bMediaPlayer?.isPlaying == false) {
                        bMediaPlayer?.start()
                    }
                    h.postDelayed(this, 235)
                }

            }
        }, 235)


        val handler = Handler()
        handler.postDelayed(object : Runnable {
            override fun run() {
                randomValues = Random.nextLong(0, 10)
                if (flag == 0) {
                    fatherAnimation.start()
                    handler.postDelayed(this, (randomValues * 1000) + 970)
                }

            }
        }, 2000)


        val handler1 = Handler()
        handler1.postDelayed(object : Runnable {
            override fun run() {
                fatherAnimation.stop()
                handler1.postDelayed(this, (randomValues * 1000) + 1205)
            }
        }, 2970)

    }

    fun showDialog() {
        val builder = AlertDialog.Builder(this@GameActivity)
        builder.setTitle("Score")
        builder.setMessage("Your Score is: " + score)
        builder.setPositiveButton("Back") { dialog, which ->
            var i = Intent(this, HomeActivity::class.java)
            startActivity(i)
        }
        val dialog: AlertDialog = builder.create()
        dialog.show()
        score = 0
    }

    fun caughtMusic() {
        cMediaPlayer = MediaPlayer.create(this, R.raw.se_maoudamashii_onepoint33)
        cMediaPlayer?.start()
    }

    fun highScores() {

        val pref = applicationContext.getSharedPreferences("MyPref", 0)
        val editor = pref.edit()
            if(pref.getInt("score1",-1) < score && pref.getInt("score2",-2)<score && pref.getInt("score3",-3)<score){
                editor.putInt("score3",pref.getInt("score2",-3))
                editor.putInt("score2",pref.getInt("score1",-1))
                editor.putInt("score1", score)
                editor.commit()
            }
            else if(pref.getInt("score2",-2) < score && pref.getInt("score3",-3) < score){
                editor.putInt("score3",pref.getInt("score2",-2))
                editor.putInt("score2", score)
                editor.commit()
            }
            else if(pref.getInt("score3",-3) < score){
                editor.putInt("score3", score)
                editor.commit()
            }

    }

    override fun onBackPressed() {
        super.onBackPressed()
        bMediaPlayer?.stop()
    }


}