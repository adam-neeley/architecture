	.data
wc_result:
	.word	0xcafed00d	# num_lines
	.word	0xcafed00d	# num_words
	.word	0xcafed00d	# num_bytes

	.text
main:
	la	$a0, textfile
	la	$a1, wc_result
	jal	wc_impl

	la	$a1, wc_result		# reload a1 (in case wc_impl trashed it)

	li	$v0, 1			# print integer
	lw	$a0, 0($a1)		# num_lines
	syscall

	li	$v0, 11			# print character
	li	$a0, ' '		# space between numbers
	syscall

	li	$v0, 1			# print integer
	lw	$a0, 4($a1)		# num_words
	syscall

	li	$v0, 11			# print character
	li	$a0, ' '		# space between numbers
	syscall

	li	$v0, 1			# print integer
	lw	$a0, 8($a1)		# num_bytes
	syscall

	li	$v0, 11			# print character
	li	$a0, '\n'		# end of line
	syscall

	li	$v0, 10			# exit
	syscall

# on entry:
#	a0 -> a string
#	a1 -> a WcResult structure
# on exit:
#	The WcResult structure is filled in with the number of lines, number
#	of words, and number of characters in the string.

wc_impl:
        # YOUR CODE GOES HERE


	.data
textfile:
	.ascii	"   This is a test file that has lots of data in it.\n"
	.ascii	"It's got    a bunch of      consecutive   spaces to test simplistic\n"
	.ascii	"implementations of wc.  The file starts with some spaces, because\n"
	.ascii	"failing to count initial spaces is a common bug in wc implementations.\n"
	.ascii	"\n"
	.ascii	"\n"
	.ascii	"\n"
	.ascii	"It's also got a few consecutive newlines, as you can see.  And look,\n"
	.ascii	"here's\ta tab character! Two\t\ttabs in a row, even. At the very end\n"
	.ascii	"of the file, there's a line containing just five spaces.\n"
	.ascii	"\n"
	.ascii	"In the meantime, let's enjoy a hearty reading of some 18th-century philosophy.\n"
	.ascii	"Here follows an excerpt from The Critique of Pure Reason by Immanuel Kant.\n"
	.ascii	"\n"
	.ascii	"\n"
	.ascii	"P 105\n"
	.ascii	"THE TRANSCENDENTAL CLUE TO THE DISCOVERY OF\n"
	.ascii	"ALL PURE CONCEPTS OF THE UNDERSTANDING\n"
	.ascii	"Section I\n"
	.ascii	"THE LOGICAL EMPLOYMENT OF THE UNDERSTANDING\n"
	.ascii	"The understanding has thus far been explained merely\n"
	.ascii	"negatively, as a non-sensible faculty of knowledge. Now since\n"
	.ascii	"without sensibility we cannot have any intuition, understanding A68\n"
	.ascii	"cannot be a faculty of intuition. But besides intuition there\n"
	.ascii	"is no other mode of knowledge except by means of concepts. B93\n"
	.ascii	"The knowledge yielded by understanding, or at least by the\n"
	.ascii	"human understanding, must therefore be by means of concepts,\n"
	.ascii	"and so is not intuitive, but discursive. Whereas all intuitions,\n"
	.ascii	"as sensible, rest on affections, concepts rest on functions. By\n"
	.ascii	"'function' I mean the unity of the act of bringing various \n"
	.ascii	"representations under one common representation. Concepts are\n"
	.ascii	"based on the spontaneity of thought, sensible intuitions on the\n"
	.ascii	"receptivity of impressions. Now the only use which the \n"
	.ascii	"understanding can make of these concepts is to judge by means of\n"
	.ascii	"them. Since no representation, save when it is an intuition,\n"
	.ascii	"is in immediate relation to an object, no concept is ever\n"
	.ascii	"related to an object immediately, but to some other representation\n"
	.ascii	"of it, be that other representation an intuition, or itself\n"
	.ascii	"a concept. Judgment is therefore the mediate knowledge of an\n"
	.ascii	"object, that is, the representation of a representation of it. In\n"
	.ascii	"every judgment there is a concept which holds of many \n"
	.ascii	"representations, and among them of a given representation that is\n"
	.ascii	"immediately related to an object. Thus in the judgment, 'all\n"
	.ascii	"bodies are divisible', the concept of the divisible applies to\n"
	.ascii	"various other concepts, but is here applied in particular to\n"
	.ascii	"the concept of body, and this concept again to certain appearances A69\n"
	.ascii	"that present themselves to us. These objects, therefore,\n"
	.ascii	"are mediately represented through the concept of divisibility.\n"
	.ascii	"Accordingly, all judgments are functions of unity among our\n"
	.ascii	"P 106\n"
	.ascii	"representations; instead of an immediate representation, a B94\n"
	.ascii	"higher representation, which comprises the immediate \n"
	.ascii	"representation and various others, is used in knowing the object,\n"
	.ascii	"and thereby much possible knowledge is collected into one.\n"
	.ascii	"Now we can reduce all acts of the understanding to judgments,\n"
	.ascii	"and the understanding may therefore be represented\n"
	.ascii	"as a faculty of judgment. For, as stated above, the \n"
	.ascii	"understanding is a faculty of thought. Thought is knowledge by\n"
	.ascii	"means of concepts. But concepts, as predicates of possible\n"
	.ascii	"judgments, relate to some representation of a not yet determined\n"
	.ascii	"object. Thus the concept of body means something, for\n"
	.ascii	"instance, metal, which can be known by means of that concept.\n"
	.ascii	"It is therefore a concept solely in virtue of its \n"
	.ascii	"comprehending other representations, by means of which it can\n"
	.ascii	"relate to objects. It is therefore the predicate of a possible\n"
	.ascii	"judgment, for instance, 'every metal is a body'. The functions\n"
	.ascii	"of the understanding can, therefore, be discovered if we can\n"
	.ascii	"give an exhaustive statement of the functions of unity in\n"
	.ascii	"judgments. That this can quite easily be done will be shown\n"
	.ascii	"in the next section.\n"
	.ascii	"THE CLUE TO THE DISCOVERY OF ALL PURE A70 B95\n"
	.ascii	"CONCEPTS OF THE UNDERSTANDING\n"
	.ascii	"Section 2\n"
	.ascii	"$9\n"
	.ascii	"THE LOGICAL FUNCTION OF THE UNDERSTANDING IN\n"
	.ascii	"JUDGMENTS\n"
	.ascii	"If we abstract from all content of a judgment, and consider\n"
	.ascii	"only the mere form of understanding, we find that the\n"
	.ascii	"function of thought in judgment can be brought under four\n"
	.ascii	"heads, each of which contains three moments. They may be\n"
	.ascii	"conveniently represented in the following table:\n"
	.ascii	"P 107\n"
	.ascii	"I\n"
	.ascii	"Quantity of Judgments\n"
	.ascii	"Universal\n"
	.ascii	"Particular\n"
	.ascii	"Singular \n"
	.ascii	"II\n"
	.ascii	"Quality\n"
	.ascii	"Affirmative\n"
	.ascii	"Negative\n"
	.ascii	"Infinite\n"
	.ascii	"III\n"
	.ascii	"Relation\n"
	.ascii	"Categorical\n"
	.ascii	"Hypothetical\n"
	.ascii	"Disjunctive\n"
	.ascii	"IV\n"
	.ascii	"Modality\n"
	.ascii	"Problematic\n"
	.ascii	"Assertoric\n"
	.ascii	"Apodeictic\n"
	.ascii	"As this division appears to depart in some, though not in B96\n"
	.ascii	"any essential respects, from the technical distinctions ordinarily\n"
	.ascii	"recognised by logicians, the following observations may A71\n"
	.ascii	"serve to guard against any possible misunderstanding.\n"
	.ascii	"1. Logicians are justified in saying that, in the employment\n"
	.ascii	"of judgments in syllogisms, singular judgments can\n"
	.ascii	"be treated like those that are universal. For, since they\n"
	.ascii	"have no extension at all, the predicate cannot relate to part\n"
	.ascii	"only of that which is contained in the concept of the subject,\n"
	.ascii	"and be excluded from the rest. The predicate is valid of that\n"
	.ascii	"concept, without any such exception, just as if it were a\n"
	.ascii	"general concept and had an extension to the whole of which\n"
	.ascii	"the predicate applied. If, on the other hand, we compare a\n"
	.ascii	"singular with a universal judgment, merely as knowledge,\n"
	.ascii	"in respect of quantity, the singular stands to the universal as\n"
	.ascii	"unity to infinity, and is therefore in itself essentially different\n"
	.ascii	"from the universal. If, therefore, we estimate a singular judgment\n"
	.ascii	"(judicium singulare), not only according to its own inner\n"
	.ascii	"validity, but as knowledge in general, according to its quantity\n"
	.ascii	"in comparison with other knowledge, it is certainly different\n"
	.ascii	"from general judgments (judicia communia), and in a complete\n"
	.ascii	"table of the moments of thought in general deserves a\n"
	.ascii	"separate place -- though not, indeed, in a logic limited to the\n"
	.ascii	"use of judgments in reference to each other. B97\n"
	.ascii	"P 108\n"
	.ascii	"2. In like manner infinite judgments must, in transcendental\n"
	.ascii	"logic, be distinguished from those that are affirmative,\n"
	.ascii	"although in general logic they are rightly classed with A72\n"
	.ascii	"them, and do not constitute a separate member of the division.\n"
	.ascii	"General logic abstracts from all content of the predicate (even\n"
	.ascii	"though it be negative); it enquires only whether the predicate\n"
	.ascii	"be ascribed to the subject or opposed to it. But transcendental\n"
	.ascii	"logic also considers what may be the worth or content of a\n"
	.ascii	"logical affirmation that is thus made by means of a merely\n"
	.ascii	"negative predicate, and what is thereby achieved in the way\n"
	.ascii	"of addition to our total knowledge. If I should say of the soul,\n"
	.ascii	"'It is not mortal', by this negative judgment I should at least\n"
	.ascii	"have warded off error. Now by the proposition, 'The soul\n"
	.ascii	"is non-mortal', I have, so far as the logical form is concerned,\n"
	.ascii	"really made an affirmation. I locate the soul in the unlimited\n"
	.ascii	"sphere of non-mortal beings. Since the mortal constitutes\n"
	.ascii	"one part of the whole extension of possible beings, and the\n"
	.ascii	"non-mortal the other, nothing more is said by my proposition\n"
	.ascii	"than that the soul is one of the infinite number of things which\n"
	.ascii	"remain over when I take away all that is mortal. The infinite\n"
	.ascii	"sphere of all that is possible is thereby only so far limited that\n"
	.ascii	"the mortal is excluded from it, and that the soul is located B98\n"
	.ascii	"in the remaining part of its extension. But, even allowing\n"
	.ascii	"for such exclusion, this extension still remains infinite, and\n"
	.ascii	"several more parts of it may be taken away without the concept\n"
	.ascii	"of the soul being thereby in the least increased, or  A73\n"
	.ascii	"determined in an affirmative manner. These judgments, though\n"
	.ascii	"infinite in respect of their logical extension, are thus, in respect\n"
	.ascii	"of the content of their knowledge, limitative only, and cannot\n"
	.ascii	"therefore be passed over in a transcendental table of all\n"
	.ascii	"moments of thought in judgments, since the function of the\n"
	.ascii	"understanding thereby expressed may perhaps be of \n"
	.ascii	"importance in the field of its pure a priori knowledge.\n"
	.ascii	"\n"
	.ascii	"\n"
	.ascii	"\n"
	.ascii	"\n"
	.ascii	"\n"
	.ascii	"     \n"
	.byte	0
