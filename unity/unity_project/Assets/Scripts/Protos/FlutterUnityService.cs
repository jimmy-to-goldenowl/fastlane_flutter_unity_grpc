using Grpc.Core;
using LoveBlocks;
using System.Threading;

public class FlutterUnityService 
{
    private Channel channel;
    private FlutterUnity.FlutterUnityClient client;
    private Connect connect;
    private CancellationTokenSource tokenSource;

    // [Unity event] Start is called before the first frame update
    public FlutterUnityService()
    {
        ConnectServer();
    }
    // [Unity event]  is called after the last frame update
    public async void Dispose()
    {
        tokenSource.Cancel();
        tokenSource.Dispose();
        await channel.ShutdownAsync();
    }
    private void ConnectServer()
    {
        channel = new Channel("127.0.0.1:8081", ChannelCredentials.Insecure);
        client = new FlutterUnity.FlutterUnityClient(channel);
    }

    public AsyncServerStreamingCall<Message> connectStream()
    {
        tokenSource = new CancellationTokenSource();
        connect = new Connect { Id = "unity", Active = true };
        return client.CreateStream(connect, cancellationToken: tokenSource.Token);
    }

    public void sendMessage(string message)
    {
        client.SendMessage(new Message { Id = connect.Id, Content = message });
    }
}
