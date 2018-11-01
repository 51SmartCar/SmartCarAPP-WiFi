//
//  remote.h
//  
//
//  Created by 韦伟 on 15/5/20.
//  Copyright (c) 2015年 william.wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nabto_client_api.h"

@interface remote : NSObject
/*
void NabtoLogStart(void);
void NabtoLogStop(void);
void SaveNabtoLog(NSString* NabtoID);
*/

/**
 * Init nabto library.
 */
int NabtoLibraryInit(void);
/**
 * Opens a TCP tunnel to a remote server through a Nabto enabled device。
 * This method for synchronous blocking mode,return to create channels the final result.
 *
 * @param tunnel      Nabto tunnel.
 * @param RemoteId    User Device id.
 * @param RemotePort  The TCP port to connect to on remoteHost.
 * @param LocalPort   The local TCP port to listen on.
 * @param times       Create channels timeout time.
 *
 * @return
 *            NTCS_CLOSED = -1,
 *                                The tunnel is closed.
 *            NTCS_CONNECTING = 0,
 *                                The tunnel is connecting.
 *            NTCS_READY_FOR_RECONNECT = 1,
 *                                The other end of the tunnel (the device) has disappeared. The client
 *                                must connect again.
 *            NTCS_UNKNOWN = 2,
 *                                The tunnel is connected and the tunnel is running on an unrecognized
 *                                connection type. This value indicates an internal error, since we
 *                                always know the underlying connection type if it exists.
 *            NTCS_LOCAL = 3,
 *                                The tunnel is connected and the tunnel is running on a local
 *                                connection (no Internet).
 *            NTCS_REMOTE_P2P = 4,
 *                                The tunnel is connected and the tunnel is running on a direct
 *                                connection (peer-to-peer).
 *            NTCS_REMOTE_RELAY = 5,
 *                                The tunnel is connected and the tunnel is running on a fallback
 *                                connection through the base-station.
 *            NTCS_REMOTE_RELAY_MICRO = 6,
 *                                The tunnel is connected and the tunnel is running on a connection
 *                                that runs through a relay node on the Internet. The device is
 *                                capable of using TCP/IP and the connection runs directly from the
 *                                device to the relay node to the client.
 *
 *
 *
 * @Sample
 * If the target device ID is"lx520.xxxxxx.p2p.rakwireless.com", the TCP server port number is 554;
 *
 *  nabto_tunnel_t tunnel_1;
 *
 *  nabto_tunnel_state_t status = [Rak_Lx52x_Remote_Connect Sync_ConnectDeviceWithTunnel:&tunnel_1 andId:@“lx520.xxxxxx.p2p.rakwireless.com” andRemotePort:554 andLocalPort:5555 andTime:60.0f];
 *
 * If create channels successfully, you can create the remote TCP connection.
 * IP address is "127.0.0.1," port number is "5555"
 */
nabto_tunnel_state_t Sync_ConnectDeviceWithTunnel(nabto_tunnel_t* tunnel, NSString* RemoteId,int RemotePort, int LocalPort, float times);
/**
 * Opens a TCP tunnel to a remote server through a Nabto enabled device。
 * This method for asynchronous mode,need to cycle check create channels results.
 *
 * @param tunnel      Nabto tunnel.
 * @param RemoteId    User Device id.
 * @param RemotePort  The TCP port to connect to on remoteHost.
 * @param LocalPort   The local TCP port to listen on.
 *
 * @return            nabto_status_t
 */
nabto_status_t Async_ConnectDeviceWithTunnel(nabto_tunnel_t* tunnel, NSString* RemoteId, int RemotePort, int LocalPort);
/**
 * Check create channels status,Detection time interval of 1 second.
 *
 * @return  nabto_tunnel_state_t
 */
nabto_tunnel_state_t CheckConnectStatus(nabto_tunnel_t* tunnel);
/**
 * If create channels is false,it will return error info.
 * @return error code.
 */
int ReturnErrorCode(nabto_tunnel_t* tunnel);
/**
 * close nabto tunnel。
 * If create a channel successful,don't use this channel must close it.
 * 
 * @return            nabto_status_t
 */
nabto_status_t CloseTunnel(nabto_tunnel_t* tunnel);

@end
