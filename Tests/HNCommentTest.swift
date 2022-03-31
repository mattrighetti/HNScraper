//
//  File.swift
//  
//
//  Created by Mattia Righetti on 3/30/22.
//

import XCTest
@testable import HNScraper

class HNCommentText: XCTestCase {
    func testInitFromHtml1() {
        let html = """
        <tr class='athing comtr' id='30857897'><td><table border='0'>  <tr>    <td class='ind'indent='3'><img src="s.gif" height="1" width="120"></td><td valign="top" class="votelinks">
              <center><a id='up_30857897'href='vote?id=30857897&amp;how=up&amp;goto=item%3Fid%3D30855419'><div class='votearrow' title='upvote'></div></a></center>    </td><td class="default"><div style="margin-top:2px; margin-bottom:-10px;"><span class="comhead">
                  <a href="user?id=zozbot234" class="hnuser">zozbot234</a> <span class="age" title="2022-03-30T17:03:25"><a href="item?id=30857897">57 minutes ago</a></span> <span id="unv_30857897"></span><span class="navs"> | <a href="#30856036" class="clicky" aria-hidden="true">root</a> | <a href="#30857704" class="clicky" aria-hidden="true">parent</a> | <a href="#30857629" class="clicky" aria-hidden="true">next</a></span> <a class="togg clicky" id="30857897" n="3" href="javascript:void(0)">[–]</a><span class="onstory"></span>                  </span></div><br><div class="comment">
                          <span class="commtext c00">Graphical programs could be checkpointed and restored as long as they don&#x27;t directly connect to the hardware. (Because the checkpoint&#x2F;restore system has no idea how to grab the hardware&#x27;s relevant state or replicate it on restore.)  This means running those apps in a hardware-independent way (e.g. using a separate Wayland instance that connects to the system one), but aside from that it ought to be usable.</span>
                      <div class='reply'>        <p><font size="1">
                              <u><a href="reply?id=30857897&amp;goto=item%3Fid%3D30855419%2330857897">reply</a></u>
                          </font>
              </div></div></td></tr>
        """
        let expectation = expectation(description: "timeout")
        let task = URLSession.shared.dataTask(with: URL(string: "http://localhost:8080/hn.json")!) { data, response, error in
            let config = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
            let comment = HNComment(fromHtml: html, withParsingConfig: config)
            XCTAssertNotNil(comment)
            XCTAssertEqual(comment!.username, "zozbot234")
            XCTAssertEqual(comment!.id, "30857897")
            XCTAssertEqual(comment!.level, 3)
            XCTAssertNil(comment!.parentId)
            XCTAssertEqual(comment!.type, .defaultType)
            XCTAssertEqual(comment!.created!, "57 minutes ago")
            XCTAssertFalse(comment!.text.isEmpty)
            XCTAssertTrue(comment!.text.hasPrefix("Graphical programs could be checkpointed and restored as long as they don&#x27;t directly connect to the hardware."))
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 10)
    }
    
    func testInitFromHtml2() {
        let html = """
        <tr class="athing comtr" id='30857322'><td><table border='0'>  <tr>    <td class='ind'indent='4'><img src="s.gif" height="1" width="160"></td><td valign="top" class="votelinks">
              <center><a id='up_30857322'href='vote?id=30857322&amp;how=up&amp;goto=item%3Fid%3D30855419'><div class='votearrow' title='upvote'></div></a></center>    </td><td class="default"><div style="margin-top:2px; margin-bottom:-10px;"><span class="comhead">
                  <a href="user?id=glorfindel66" class="hnuser">glorfindel66</a> <span class="age" title="2022-03-30T16:20:57"><a href="item?id=30857322">1 hour ago</a></span> <span id="unv_30857322"></span><span class="navs"> | <a href="#30856036" class="clicky" aria-hidden="true">root</a> | <a href="#30856383" class="clicky" aria-hidden="true">parent</a> | <a href="#30857275" class="clicky" aria-hidden="true">next</a></span> <a class="togg clicky" id="30857322" n="2" href="javascript:void(0)">[–]</a><span class="onstory"></span>                  </span></div><br><div class="comment">
                          <span class="commtext c00">That’s not at all what Linux namespaces permit. It’s a side effect of using them that could be leveraged using something like CRIU, sure, but it’s not what they’re for and they’re not a building block for anything mentioned in the portion of their comment you quoted.<p>Namespaces simply make the kernel lie when asked about sockets and users and such. It’s intended for isolation on a single server. They’re next to useless in distributed work, particularly the kind being discussed here (Plan 9ish). You actually want the opposite: to accomplish that, you want the kernel to lie even harder and make things up in the context of those interfaces, rather than hide things. Namespaces don’t really get you there in their current form.</span>
                      <div class='reply'>        <p><font size="1">
                              <u><a href="reply?id=30857322&amp;goto=item%3Fid%3D30855419%2330857322">reply</a></u>
                          </font>
              </div></div></td></tr>
        """
        let expectation = expectation(description: "timeout")
        let task = URLSession.shared.dataTask(with: URL(string: "http://localhost:8080/hn.json")!) { data, response, error in
            let config = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
            let comment = HNComment(fromHtml: html, withParsingConfig: config)
            XCTAssertNotNil(comment)
            XCTAssertEqual(comment!.username, "glorfindel66")
            XCTAssertEqual(comment!.id, "30857322")
            XCTAssertEqual(comment!.level, 4)
            XCTAssertNil(comment!.parentId)
            XCTAssertEqual(comment!.type, .defaultType)
            XCTAssertEqual(comment!.created!, "1 hour ago")
            XCTAssertFalse(comment!.text.isEmpty)
            XCTAssertTrue(comment!.text.hasPrefix("That’s not at all what Linux namespaces permit."))
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 10)
    }
    
    func testInitFromHtmlDownvoted() {
        let html = """
        <tr class="athing comtr" id="30861845"><td><table border="0">  <tbody><tr>    <td class="ind" indent="1"><img src="s.gif" width="40" height="1"></td><td class="votelinks" valign="top">
              <center><a id="up_30861845" href="vote?id=30861845&amp;how=up&amp;goto=item%3Fid%3D30861564"><div class="votearrow" title="upvote"></div></a></center>    </td><td class="default"><div style="margin-top:2px; margin-bottom:-10px;"><span class="comhead">
                  <a href="user?id=mikeInAlaska" class="hnuser">mikeInAlaska</a> <span class="age" title="2022-03-30T22:52:55"><a href="item?id=30861845">1 hour ago</a></span> <span id="unv_30861845"></span><span class="navs"> | <a href="#30861730" class="clicky" aria-hidden="true">parent</a> | <a href="#30862214" class="clicky" aria-hidden="true">prev</a></span> <a class="togg clicky" id="30861845" n="1" href="javascript:void(0)">[–]</a><span class="onstory"></span>                  </span></div><br><div class="comment">
                          <span class="commtext c5a">Maybe Boston Dynamics has indeed done a lot better than The John Hopkins Beast</span>
                      <div class="reply">        <p><font size="1">
                              <u><a href="reply?id=30861845&amp;goto=item%3Fid%3D30861564%2330861845">reply</a></u>
                          </font>
              </p></div></div></td></tr>
                </tbody></table></td></tr>
        """
        let expectation = expectation(description: "timeout")
        let task = URLSession.shared.dataTask(with: URL(string: "http://localhost:8080/hn.json")!) { data, response, error in
            let config = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
            let comment = HNComment(fromHtml: html, withParsingConfig: config)
            XCTAssertNotNil(comment)
            XCTAssertEqual(comment!.username, "mikeInAlaska")
            XCTAssertEqual(comment!.id, "30861845")
            XCTAssertEqual(comment!.level, 1)
            XCTAssertNil(comment!.parentId)
            XCTAssertEqual(comment!.type, .defaultType)
            XCTAssertEqual(comment!.created!, "1 hour ago")
            XCTAssertFalse(comment!.text.isEmpty)
            XCTAssertTrue(comment!.text.hasPrefix("Maybe Boston Dynamics has indeed done a lot better than The John Hopkins Beast"))
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 10)
    }
}
