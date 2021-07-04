using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;
using Grpc.Core;
using LoveBlocks;

public class FlutterUnityBehaviourScript : MonoBehaviour
{
    
    [SerializeField]
    private Text text;
    FlutterUnityService service;
    List<Message> messages = new List<Message>();

    // [Unity event] Start is called before the first frame update
    private void Start()
    {
        service = new FlutterUnityService();
        connectStream();
    }
    // [Unity event]  is called after the last frame update
    private void OnApplicationQuit()
    {
        service.Dispose();
        Debug.Log("OnApplicationQuit");
    }


    private async void connectStream()
    {
        try
        {
            using (var _asyncStreaming = service.connectStream())
            {
                var _responseStream = _asyncStreaming.ResponseStream;
                while (await _responseStream.MoveNext())
                //if (await _responseStream.MoveNext())
                {
                    var message = _responseStream.Current;
                    messages.Add(message);
                    text.text = string.Format("Message: {0} - {1}", message.Id, message.Content);
                    Debug.Log(text.text);
                }
                _responseStream = null;
                _asyncStreaming.Dispose();
            }
        }
        catch (RpcException ex) when (ex.StatusCode == StatusCode.Cancelled)
        {
            Console.WriteLine("Stream cancelled.");
        }
        catch (Exception e)
        {
            Debug.Log(e);
        }
    }

    private void sendMessage()
    {
        string body = string.Format("Send at {0}:{1}" , DateTime.Now.Minute, DateTime.Now.Second);
        service.sendMessage(body);
    }

   
    public void onCLickSendMessage()
    {
        sendMessage();
    }
}

